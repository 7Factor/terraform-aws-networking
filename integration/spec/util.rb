def has_correct_configuration(type, az)
  it { should exist}
  it { should be_available }
  it { should have_tag('Name').value(type + ' Subnet (' + az +')')}
  its('vpc.id') { should eq ENVVARS[:vpc_id][:value] }
  its(:availability_zone) { should eq az}
  its(:available_ip_address_count) { should eq 251}
  its(:map_public_ip_on_launch) { should eq false}
end