Fabricator(:period) do
  day { [*(0..6)].sample }
  ord { [*(1..6)].sample }
end
