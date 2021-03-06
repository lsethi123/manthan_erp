class FeeGradeBucket < ActiveRecord::Base
  has_many :grade_wise_fees, :dependent => :destroy
  has_many :grade_bucket_mappings, :dependent => :destroy
  

  def self.save_bulk(fee_grade_buckets)
    return false unless fee_grade_buckets.map(&:valid?).all?
    ActiveRecord::Base.transaction do
      fee_grade_buckets.map(&:save!)
      GradeBucketMapping.generate_mapping
    end
  end
  
  def self.find_grade_bucket_by_grade(grade)
    #if is_number?(grade)
      FeeGradeBucket.where("? between grade_from and grade_to", grade).first
    # else
    #   FeeGradeBucket.where("grade_from = ? or grade_to = ? ", grade, grade).first
    # end
  end

  def bucket_name
    "#{self.from_grade_name} to #{self.to_grade_name}"
  end

  def from_grade_name
    GradeMaster.find(self.grade_from).grade_name
  end

  def to_grade_name
    GradeMaster.find(self.grade_to).grade_name
  end

  def self.is_number?(str)
    !!(str =~ /\A[-+]?[0-9]+\z/)
  end

end
