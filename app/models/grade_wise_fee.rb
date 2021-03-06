class GradeWiseFee < ActiveRecord::Base
  belongs_to :fee_grade_bucket
  belongs_to :fee_type
  
  scope :find_by_fee_bucket_id_and_fee_type_id, lambda{|bucket, fee_type| where("fee_grade_bucket_id = ? and fee_type_id = ?", bucket.id, fee_type.id)}

  scope :belongs_to_fee_grade_bucket, lambda{|bucket_id| where(:fee_grade_bucket_id => bucket_id)}
  
  scope :total_grade_fee, lambda{|bucket_id| belongs_to_fee_grade_bucket(bucket_id).sum(:amount_in_rupees)}

  def self.make_object_with_grade_and_fee_type(grade, fee_type)
    grade_wise_fee = GradeWiseFee.new
    grade_wise_fee.fee_grade_bucket = grade
    grade_wise_fee.fee_type = fee_type
    grade_wise_fee
  end

  def self.fee_structure_defined?
    GradeWiseFee.count > 0 and TermWiseGradeFee.count > 0 and MonthlyPdcAmount.count> 0
  end


  # def amount_in_rupees
  #   (read_attribute(:amount_in_rupees).to_f/RuleEngine.new.value(:amount, :unit))
  # end

  # def amount_in_rupees=(amt)
  #   write_attribute(:amount_in_rupees, (amt.to_f * RuleEngine.new.value(:amount, :unit)))
  # end

  
end
