import solutions.world1_addition
import mynat.mul


/- Here's what you get from the import:

1) The following data:
  * a function called mynat.mul, and notation a * b for this function

2) The following axioms:

  * `mul_zero : ∀ a : mynat, a * 0 = 0`
  * `mul_succ : ∀ a b : mynat, a * succ(b) = a * b + a`

These axiom between them tell you how to work out a * x for every x; use induction on x to
reduce to the case either `x = 0` or `x = succ b`, and then use `mul_zero` or `mul_succ` appropriately.
-/

-- main goal: comm_semiring

--comm_semiring [] -- collectible_06
--  semiring [] -- collectible_05
--  {
--    add_comm_monoid -- (collectible_02)
--    monoid -- collectible_04
--      semigroup [mul_assoc]
--        (has_mul)
  --    (has_one)
  --  distrib [left_distrib, right_distrib]
--     (has_mul)
--     (has_add)
--    mul_zero_class [zero_mul, mul_zero] -- collectible_03
--     (has_mul)
--     (has_zero)
--  }
--  comm_monoid []
--    monoid (see above)
--    comm_semigroup [mul_comm]
--      semigroup (see above)


namespace mynat

lemma zero_mul (m : mynat) : 0 * m = 0 :=
begin [nat_num_game]
  induction m with d hd,
  {
    rw mul_zero,
    refl
  },
  {
    rw mul_succ,
    rw hd,
    rw add_zero,
    refl
  }
end

def collectible_3 : mul_zero_class mynat := by structure_helper

lemma mul_one (m : mynat) : m * 1 = m :=
begin [nat_num_game]
  rw one_eq_succ_zero,
  rw mul_succ,
  rw mul_zero,
  exact zero_add m,
end

lemma one_mul (m : mynat) : 1 * m = m :=
begin [nat_num_game]
  induction m with d hd,
  {
    rw mul_zero,
    refl,
  },
  {
    rw mul_succ,
    rw hd,
    exact add_one_eq_succ d,
  }
end

-- mul_assoc immediately, leads to this:
-- ⊢ a * (b * d) + a * b = a * (b * d + b)

lemma mul_add (a b c : mynat) : a * (b + c) = a * b + a * c :=
begin [nat_num_game]
  induction c with d hd,
  { rewrite [add_zero, mul_zero, add_zero],
  },
  {
    rw add_succ,
-- or    show a * succ (b + d) = _,
    rw mul_succ,
-- or    show a * (b + d) + _ = _,
    rw hd,
    rw mul_succ,
    apply add_assoc, -- ;-)
  }
end

-- hide this
def left_distrib := mul_add -- stupid field name, 
-- I just don't instinctively know what left_distrib means

lemma mul_assoc (a b c : mynat) : (a * b) * c = a * (b * c) :=
begin [nat_num_game]
  induction c with d hd,
  { 
    refl
  },
  {
    rw mul_succ,
    rw mul_succ,
--    show (a * b) * d + (a * b) = _,
    rw hd,
--    show _ = a * (b * d + _),
    rw mul_add,
    refl,
  }
end

def collectible_4 : monoid mynat := by structure_helper
--#print axioms collectible_4


-- goal : mul_comm. 
-- mul_comm leads to ⊢ a * d + a = succ d * a
-- so perhaps we need add_mul
-- but add_mul leads to either a+b+c=a+c+b or (a+b)+(c+d)=(a+c)+(b+d)
-- (depending on whether we do induction on b or c)



-- I need this for mul_comm
lemma succ_mul (a b : mynat) : succ a * b = a * b + b :=
begin [nat_num_game]
  induction b with d hd,
  {
    refl
  },
  {
    rw mul_succ,
    rw mul_succ,
--    show (succ a) * d + (succ a) = (a * d + a) + _,
    rw hd,
    rw add_succ,
    rw add_succ,
    rw add_right_comm,
    refl,
  }
end

-- turns out I don't actually need this for mul_comm
lemma add_mul (a b c : mynat) : (a + b) * c = a * c + b * c :=
begin [nat_num_game]
  induction' b with d hd,
  { 
    rw zero_mul,
    rw add_zero,
    rw add_zero,
    refl
  },
  {
    rw add_succ,
    rw succ_mul,
    rw hd,
    rw succ_mul,
    rw add_assoc,
    refl
  }
end

def right_distrib := add_mul -- stupid field name, 

def collectible_05 : semiring mynat := by structure_helper 

lemma mul_comm (a b : mynat) : a * b = b * a :=
begin [nat_num_game]
  induction' b with d hd,
  { 
    rw zero_mul,
    rw mul_zero,
    refl,
  },
  {
    rw succ_mul,
    rw ←hd,
    rw mul_succ,
    refl,
  }
end

def collectible_06 : comm_semiring mynat := by structure_helper

-- this is < axiom 4
theorem mul_pos (a b : mynat) : a ≠ 0 → b ≠ 0 → a * b ≠ 0 :=
begin [nat_num_game]
  intros ha hb,
  intro hab,
  cases b with b,
    apply hb,
    refl,
  rw mul_succ at hab,
  apply ha,
  cases a with a,
    refl,
  rw add_succ at hab,
  exfalso,
  apply succ_ne_zero hab
end

-- this involves a lot of cases. Would be really cool
-- to have some sort of trickery instead of all the {}s.
theorem mul_eq_zero_iff : ∀ (a b : mynat), a * b = 0 ↔ a = 0 ∨ b = 0 :=
begin [nat_num_game]
  intros a b,
  split, swap,
    intro hab, cases hab,
      rw hab, rw zero_mul, refl,
    rw hab, rw mul_zero, refl,
  intro hab,
  cases a with d,
    left, refl,
  cases b with e he,
    right, refl,
  exfalso,
  rw mul_succ at hab,
  rw add_succ at hab,
  exact succ_ne_zero hab,
end

theorem eq_zero_or_eq_zero_of_mul_eq_zero ⦃a b : mynat⦄ (h : a * b = 0) : a = 0 ∨ b = 0 :=
begin [nat_num_game]
  revert a,
  induction b with c hc,
  { intros a ha,
    right, refl,
  },
  { intros a ha,
    rw mul_succ at ha,
    left,
    apply add_left_eq_zero ha
  }
end

instance : comm_semiring mynat := by structure_helper

-- I use this in world3_le_solutions
theorem mul_left_cancel ⦃a b c : mynat⦄ (ha : a ≠ 0) : a * b = a * c → b = c :=
begin [nat_num_game]
  revert b,
  induction c with d hd,
  { intro b,
    rw mul_zero,
    intro h,
    cases (eq_zero_or_eq_zero_of_mul_eq_zero h),
      exfalso,
      apply ha,
      assumption,
    assumption
  },
  { intros b hb,
    cases b with c,
    { rw mul_zero at hb,
      rw mul_succ at hb,
      exfalso,
      apply ha,
      rw eq_comm at hb,
      apply add_left_eq_zero hb,
    },
    { congr, -- c = d -> succ c = succ d
      apply hd,
      rw mul_succ at hb,
      rw mul_succ at hb,
      apply add_right_cancel hb
    }
  }
end

end mynat
