require 'spec_helper'

describe Child do
    it { should validate_presence_of :parent1 }
    it { should validate_presence_of :parent2 }
end
