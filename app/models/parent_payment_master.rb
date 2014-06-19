class ParentPaymentMaster < ActiveRecord::Base
  validates :payment_type_id, :presence => true
  belongs_to :parent 
  belongs_to :student, :class_name => "StudentMaster"
  belongs_to :payment_type
  has_many :parent_cheques
  has_many :parent_payment_transactions
  accepts_nested_attributes_for :parent_cheques
  accepts_nested_attributes_for :parent_payment_transactions

  def self.new_student_payment_master(student_id)
    payment_master = ParentPaymentMaster.new
    payment_master.student_id = student_id
    payment_master
  end
  
  def self.new_payment_master(params)
    payment_master = ParentPaymentMaster.new
    student = StudentMaster.find(params[:student_id])
    pmnt_type = PaymentType.find(params[:payment_type_id])
    payment_master.parent= student.parent
    payment_master.student = student
    payment_master.payment_type = pmnt_type
    payment_master.prepare_payment(params)
    payment_master
  end

  def prepare_payment(params)
    if annual_payment? or term_wise_payment?
      transaction = add_payment_transaction(params[:parent_payment_transaction])
      if params[:parent_payment_transaction][:transaction_type] == "cash" 
        transaction.status = "cleared"
      else
        transaction.status = "pending"
        parent_cheques << generate_parent_cheque(ParentCheque.parent_cheque_params(params[:parent_cheques]), student)do |cheque|
          term_def_id = params[:parent_payment_transaction][:term_definition_id]
          cheque.amount_in_rupees = TermWiseGradeFee.belongs_to_term_difinition(term_def_id).belongs_to_fee_grade_bucket(student.grade_bucket_id).first.amount_real_value
          cheque.term_definition_id = term_def_id
          cheque.parent_payment_transaction = transaction
        end
      end
      parent_payment_transactions << transaction
    elsif pmnt_type.code == "monthly"
      new_parent_cheque_entries(params[:parent_cheques], student)
    end
  end

  def add_payment_transaction(transaction_params)
    ParentPaymentTransaction.new(:transaction_date => DateTime.now, :amount_in_rupees => transaction_params[:amount_in_rupees], :transaction_type => transaction_params[:transaction_type], :term_definition_id => transaction_params[:term_definition_id], :particulars => transaction_params[:particulars]);
  end

  def new_parent_cheque_entries(parent_cheque_params, student)
    parent_cheque_params.each do |pdc|
      if pdc[:cheque_number].present?
        self.parent_cheques << generate_parent_cheque(pdc, student) do |cheque|
          cheque.cheque_date = cheque.post_dated_cheque.date
          cheque.amount_in_rupees = MonthlyPdcAmount.belongs_to_post_dated_cheque(cheque.post_dated_cheque).belongs_to_fee_grade_bucket(student.grade_bucket_id).first.amount_real_value
        end
      end
    end
  end

  def generate_parent_cheque(cheque_params, student)
    parent_cheque = ParentCheque.new(cheque_params)
    parent_cheque.status = "pending"
    yield(parent_cheque) if block_given?
    # parent_cheque.parent = student.parent
    # parent_cheque.student = student
    parent_cheque
  end
  
  def term_wise_payment?
    payment_code == "term_wise"
  end

  def monthly_payment?
    payment_code == "monthly"
  end

  def annual_payment?
    payment_code == "annaul"
  end
  
  def payment_code
    self.payment_type.code
  end

  def next_term_fee(fee_grade_bucket = student.grade_bucket_id)
    term_wise_grade_fee = TermWiseGradeFee.belongs_to_fee_grade_bucket(fee_grade_bucket)
    term_wise_grade_fee = term_wise_grade_fee.student_unpaid_terms_in_transactions(parent_payment_transactions) unless parent_payment_transactions.empty?
    term_wise_grade_fee = term_wise_grade_fee.student_unpaid_terms_in_parent_cheques(parent_cheques) unless parent_cheques.empty?
    term_wise_grade_fee.first
  end

  def fee_type_contribution_percentages
    total = total_applicable_grade_fee
    contributions = []
    grade_wise_fees.each do |grade_fee|
      if student.fee_type_applicable?(grade_fee.fee_type.fee_type)
        percentage = (grade_fee.amount_in_rupees/total) * 100 
        contributions << {:fee_type_id => grade_fee.fee_type.id, :fee_type => grade_fee.fee_type.fee_type, :contribution_percent => percentage}
      end
    end
    contributions
  end

  def total_applicable_grade_fee
    grade_wise_fees.select{|grade_fee| student.fee_type_applicable?(grade_fee.fee_type.fee_type)}.inject(0.0){|sum, grade_fee| sum+grade_fee.amount_in_rupees}
  end

  def grade_wise_fees
    @grade_wise_fees ||= GradeWiseFee.belongs_to_fee_grade_bucket(student.grade_bucket_id)
  end
  
end
