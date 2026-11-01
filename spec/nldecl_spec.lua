local lester = require 'nelua.thirdparty.lester'
local describe, it = lester.describe, lester.it

local expect = require 'spec.tools.expect'
local nldecl = require 'nelua.plugins.nldecl'

describe("nldecl", function()

it("pointers to function types", function()
  local code = nldecl.generate_bindings_from_c_code([[
typedef int cb_func(void* ud);
typedef int (*cb_fptr)(void* ud);
void cb_set_functype(cb_func* f);
void cb_set_fptr(cb_fptr f);
void cb_set_fptr_ptr(cb_fptr* f);
void cb_set_inline(int (*f)(void* ud));
void cb_set_inline_ptr(int (**f)(void* ud));
]], {include_names = {'^cb_'}})
  -- nelua function types are already pointers, also when declared through a typedef
  expect.contains('cb_set_functype(f: function(ud: pointer): cint)', code)
  expect.contains('cb_set_fptr(f: cb_fptr)', code)
  expect.contains('cb_set_inline(f: function(ud: pointer): cint)', code)
  -- pointers to function pointers keep the pointer
  expect.contains('cb_set_fptr_ptr(f: *cb_fptr)', code)
  expect.contains('cb_set_inline_ptr(f: *function(ud: pointer): cint)', code)
end)

end)
