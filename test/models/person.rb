class Person < AbstractModel

  #insert the names of the form fields here
  column :email, :string
  column :postal_code, :string
  
  validates_postal_code_for :postal_code, :allow_blank => true
  validates_email_for       :email, :allow_blank => true
end