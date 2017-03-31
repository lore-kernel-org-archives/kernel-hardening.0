Date: Fri, 31 Mar 2017 12:59:04 +0800
From: kbuild test robot <lkp@intel.com>
Message-ID: <201703311229.2A8sv4Z2%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="KsGdsel6WgEHnImy"
Content-Disposition: inline
In-Reply-To: <20170329203908.GA39222@beast>
Subject: [kernel-hardening] Re: [PATCH] x86/fpu: move FPU state into separate cache
To: Kees Cook <keescook@chromium.org>
Cc: kbuild-all@01.org, linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>, Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Dave Hansen <dave.hansen@linux.intel.com>, Yu-cheng Yu <yu-cheng.yu@intel.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Borislav Petkov <bp@suse.de>, Christian Borntraeger <borntraeger@de.ibm.com>, Thomas Garnier <thgarnie@google.com>, Brian Gerst <brgerst@gmail.com>, He Chen <he.chen@linux.intel.com>, Mathias Krause <minipli@googlemail.com>, Fenghua Yu <fenghua.yu@intel.com>, Piotr Luc <piotr.luc@intel.com>, Kyle Huey <me@kylehuey.com>, Len Brown <len.brown@intel.com>, kvm@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Kees,

[auto build test ERROR on kvm/linux-next]
[also build test ERROR on v4.11-rc4 next-20170330]
[cannot apply to tip/x86/core]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Kees-Cook/x86-fpu-move-FPU-state-into-separate-cache/20170331-110507
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git linux-next
config: i386-randconfig-r0-201713 (attached as .config)
compiler: gcc-5 (Debian 5.4.1-2) 5.4.1 20160904
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

All error/warnings (new ones prefixed by >>):

   arch/x86/math-emu/fpu_entry.c: In function 'valid_prefix':
   arch/x86/math-emu/fpu_system.h:50:24: error: request for member 'soft' in something not a structure or union
    #define FPU_info  (I387->soft.info)
                           ^
   include/linux/compiler.h:178:40: note: in definition of macro 'likely'
    # define likely(x) __builtin_expect(!!(x), 1)
                                           ^
   arch/x86/include/asm/uaccess.h:100:10: note: in expansion of macro '__range_not_ok'
     likely(!__range_not_ok(addr, size, user_addr_max()));  \
             ^
   arch/x86/math-emu/fpu_system.h:80:36: note: in expansion of macro 'access_ok'
    #define FPU_access_ok(x,y,z) if ( !access_ok(x,y,z) ) \
                                       ^
   arch/x86/math-emu/fpu_system.h:95:31: note: in expansion of macro 'FPU_access_ok'
    #define FPU_code_access_ok(z) FPU_access_ok(VERIFY_READ,(void __user *)FPU_EIP,z)
                                  ^
   arch/x86/math-emu/fpu_system.h:57:20: note: in expansion of macro 'FPU_info'
    #define FPU_EIP   (FPU_info->regs->ip)
                       ^
   arch/x86/math-emu/fpu_system.h:95:72: note: in expansion of macro 'FPU_EIP'
    #define FPU_code_access_ok(z) FPU_access_ok(VERIFY_READ,(void __user *)FPU_EIP,z)
                                                                           ^
   arch/x86/math-emu/fpu_entry.c:558:2: note: in expansion of macro 'FPU_code_access_ok'
     FPU_code_access_ok(1);
     ^
   In file included from arch/x86/math-emu/fpu_entry.c:35:0:
   arch/x86/math-emu/fpu_system.h:50:24: error: request for member 'soft' in something not a structure or union
    #define FPU_info  (I387->soft.info)
                           ^
   arch/x86/math-emu/fpu_system.h:81:16: note: in expansion of macro 'FPU_info'
        math_abort(FPU_info,SIGSEGV)
                   ^
   arch/x86/math-emu/fpu_system.h:95:31: note: in expansion of macro 'FPU_access_ok'
    #define FPU_code_access_ok(z) FPU_access_ok(VERIFY_READ,(void __user *)FPU_EIP,z)
                                  ^
   arch/x86/math-emu/fpu_entry.c:558:2: note: in expansion of macro 'FPU_code_access_ok'
     FPU_code_access_ok(1);
     ^
   In file included from include/asm-generic/bug.h:4:0,
                    from arch/x86/include/asm/bug.h:35,
                    from include/linux/bug.h:4,
                    from include/linux/signal.h:4,
                    from arch/x86/math-emu/fpu_entry.c:27:
   arch/x86/math-emu/fpu_system.h:50:24: error: request for member 'soft' in something not a structure or union
    #define FPU_info  (I387->soft.info)
                           ^
   include/linux/compiler.h:178:40: note: in definition of macro 'likely'
    # define likely(x) __builtin_expect(!!(x), 1)
                                           ^
   arch/x86/include/asm/uaccess.h:100:10: note: in expansion of macro '__range_not_ok'
     likely(!__range_not_ok(addr, size, user_addr_max()));  \
             ^
   arch/x86/math-emu/fpu_system.h:80:36: note: in expansion of macro 'access_ok'
    #define FPU_access_ok(x,y,z) if ( !access_ok(x,y,z) ) \
                                       ^
   arch/x86/math-emu/fpu_system.h:95:31: note: in expansion of macro 'FPU_access_ok'
    #define FPU_code_access_ok(z) FPU_access_ok(VERIFY_READ,(void __user *)FPU_EIP,z)
                                  ^
   arch/x86/math-emu/fpu_system.h:57:20: note: in expansion of macro 'FPU_info'
    #define FPU_EIP   (FPU_info->regs->ip)
                       ^
   arch/x86/math-emu/fpu_system.h:95:72: note: in expansion of macro 'FPU_EIP'
    #define FPU_code_access_ok(z) FPU_access_ok(VERIFY_READ,(void __user *)FPU_EIP,z)
                                                                           ^
   arch/x86/math-emu/fpu_entry.c:602:4: note: in expansion of macro 'FPU_code_access_ok'
       FPU_code_access_ok(1);
       ^
   In file included from arch/x86/math-emu/fpu_entry.c:35:0:
   arch/x86/math-emu/fpu_system.h:50:24: error: request for member 'soft' in something not a structure or union
    #define FPU_info  (I387->soft.info)
                           ^
   arch/x86/math-emu/fpu_system.h:81:16: note: in expansion of macro 'FPU_info'
        math_abort(FPU_info,SIGSEGV)
                   ^
   arch/x86/math-emu/fpu_system.h:95:31: note: in expansion of macro 'FPU_access_ok'
    #define FPU_code_access_ok(z) FPU_access_ok(VERIFY_READ,(void __user *)FPU_EIP,z)
                                  ^
   arch/x86/math-emu/fpu_entry.c:602:4: note: in expansion of macro 'FPU_code_access_ok'
       FPU_code_access_ok(1);
       ^
   arch/x86/math-emu/fpu_entry.c: In function 'math_abort':
   arch/x86/math-emu/fpu_system.h:50:24: error: request for member 'soft' in something not a structure or union
    #define FPU_info  (I387->soft.info)
                           ^
   arch/x86/math-emu/fpu_system.h:57:20: note: in expansion of macro 'FPU_info'
    #define FPU_EIP   (FPU_info->regs->ip)
                       ^
   arch/x86/math-emu/fpu_entry.c:626:2: note: in expansion of macro 'FPU_EIP'
     FPU_EIP = FPU_ORIG_EIP;
     ^
   arch/x86/math-emu/fpu_system.h:50:24: error: request for member 'soft' in something not a structure or union
    #define FPU_info  (I387->soft.info)
                           ^
   arch/x86/math-emu/fpu_system.h:58:24: note: in expansion of macro 'FPU_info'
    #define FPU_ORIG_EIP  (FPU_info->___orig_eip)
                           ^
   arch/x86/math-emu/fpu_entry.c:626:12: note: in expansion of macro 'FPU_ORIG_EIP'
     FPU_EIP = FPU_ORIG_EIP;
               ^
   arch/x86/math-emu/fpu_entry.c: In function 'fpregs_soft_set':
>> arch/x86/math-emu/fpu_entry.c:646:55: error: request for member 'soft' in something not a structure or union
     struct swregs_state *s387 = &target->thread.fpu.state.soft;
                                                          ^
   arch/x86/math-emu/fpu_entry.c: In function 'fpregs_soft_get':
   arch/x86/math-emu/fpu_entry.c:698:55: error: request for member 'soft' in something not a structure or union
     struct swregs_state *s387 = &target->thread.fpu.state.soft;
                                                          ^
--
      ^
   arch/x86/math-emu/errors.c: In function 'set_precision_flag_down':
   arch/x86/math-emu/fpu_system.h:72:28: error: request for member 'soft' in something not a structure or union
    #define control_word  (I387->soft.cwd)
                               ^
   arch/x86/math-emu/errors.c:553:6: note: in expansion of macro 'control_word'
     if (control_word & CW_Precision) { /* The masked response */
         ^
   arch/x86/math-emu/fpu_system.h:71:30: error: request for member 'soft' in something not a structure or union
    #define partial_status  (I387->soft.swd)
                                 ^
   arch/x86/math-emu/errors.c:554:3: note: in expansion of macro 'partial_status'
      partial_status &= ~SW_C1;
      ^
   arch/x86/math-emu/fpu_system.h:71:30: error: request for member 'soft' in something not a structure or union
    #define partial_status  (I387->soft.swd)
                                 ^
   arch/x86/math-emu/errors.c:555:3: note: in expansion of macro 'partial_status'
      partial_status |= SW_Precision;
      ^
   arch/x86/math-emu/errors.c: In function 'denormal_operand':
   arch/x86/math-emu/fpu_system.h:72:28: error: request for member 'soft' in something not a structure or union
    #define control_word  (I387->soft.cwd)
                               ^
   arch/x86/math-emu/errors.c:562:6: note: in expansion of macro 'control_word'
     if (control_word & CW_Denormal) { /* The masked response */
         ^
   arch/x86/math-emu/fpu_system.h:71:30: error: request for member 'soft' in something not a structure or union
    #define partial_status  (I387->soft.swd)
                                 ^
   arch/x86/math-emu/errors.c:563:3: note: in expansion of macro 'partial_status'
      partial_status |= SW_Denorm_Op;
      ^
   arch/x86/math-emu/errors.c: In function 'arith_overflow':
   arch/x86/math-emu/fpu_system.h:72:28: error: request for member 'soft' in something not a structure or union
    #define control_word  (I387->soft.cwd)
                               ^
   arch/x86/math-emu/errors.c:575:6: note: in expansion of macro 'control_word'
     if (control_word & CW_Overflow) {
         ^
   arch/x86/math-emu/fpu_system.h:72:28: error: request for member 'soft' in something not a structure or union
    #define control_word  (I387->soft.cwd)
                               ^
   arch/x86/math-emu/errors.c:586:6: note: in expansion of macro 'control_word'
     if (control_word & CW_Overflow) {
         ^
   arch/x86/math-emu/errors.c: In function 'arith_underflow':
   arch/x86/math-emu/fpu_system.h:72:28: error: request for member 'soft' in something not a structure or union
    #define control_word  (I387->soft.cwd)
                               ^
   arch/x86/math-emu/errors.c:603:6: note: in expansion of macro 'control_word'
     if (control_word & CW_Underflow) {
         ^
   arch/x86/math-emu/fpu_system.h:71:30: error: request for member 'soft' in something not a structure or union
    #define partial_status  (I387->soft.swd)
                                 ^
   arch/x86/math-emu/errors.c:607:4: note: in expansion of macro 'partial_status'
       partial_status &= ~SW_C1; /* Round down. */
       ^
   arch/x86/math-emu/fpu_system.h:72:28: error: request for member 'soft' in something not a structure or union
    #define control_word  (I387->soft.cwd)
                               ^
   arch/x86/math-emu/errors.c:618:6: note: in expansion of macro 'control_word'
     if (control_word & CW_Underflow) {
         ^
   arch/x86/math-emu/errors.c: In function 'FPU_stack_overflow':
   arch/x86/math-emu/fpu_system.h:72:28: error: request for member 'soft' in something not a structure or union
    #define control_word  (I387->soft.cwd)
                               ^
   arch/x86/math-emu/errors.c:631:6: note: in expansion of macro 'control_word'
     if (control_word & CW_Invalid) {
         ^
   arch/x86/math-emu/fpu_system.h:75:20: error: request for member 'soft' in something not a structure or union
    #define top   (I387->soft.ftop)
                       ^
   arch/x86/math-emu/errors.c:633:3: note: in expansion of macro 'top'
      top--;
      ^
   arch/x86/math-emu/errors.c: In function 'FPU_stack_underflow':
   arch/x86/math-emu/fpu_system.h:72:28: error: request for member 'soft' in something not a structure or union
    #define control_word  (I387->soft.cwd)
                               ^
   arch/x86/math-emu/errors.c:646:6: note: in expansion of macro 'control_word'
     if (control_word & CW_Invalid) {
         ^
   arch/x86/math-emu/errors.c: In function 'FPU_stack_underflow_i':
   arch/x86/math-emu/fpu_system.h:72:28: error: request for member 'soft' in something not a structure or union
    #define control_word  (I387->soft.cwd)
                               ^
   arch/x86/math-emu/errors.c:660:6: note: in expansion of macro 'control_word'
     if (control_word & CW_Invalid) {
         ^
   arch/x86/math-emu/errors.c: In function 'FPU_stack_underflow_pop':
   arch/x86/math-emu/fpu_system.h:72:28: error: request for member 'soft' in something not a structure or union
    #define control_word  (I387->soft.cwd)
                               ^
   arch/x86/math-emu/errors.c:674:6: note: in expansion of macro 'control_word'
     if (control_word & CW_Invalid) {
         ^
   arch/x86/math-emu/errors.c: In function 'real_1op_NaN':
>> arch/x86/math-emu/errors.c:407:1: warning: control reaches end of non-void function [-Wreturn-type]
    }
    ^
   arch/x86/math-emu/errors.c: In function 'real_2op_NaN':
   arch/x86/math-emu/errors.c:491:1: warning: control reaches end of non-void function [-Wreturn-type]
    }
    ^
   arch/x86/math-emu/errors.c: In function 'arith_invalid':
   arch/x86/math-emu/errors.c:507:1: warning: control reaches end of non-void function [-Wreturn-type]
    }
    ^
   arch/x86/math-emu/errors.c: In function 'FPU_divide_by_zero':
   arch/x86/math-emu/errors.c:526:1: warning: control reaches end of non-void function [-Wreturn-type]
    }
    ^
   arch/x86/math-emu/errors.c: In function 'set_precision_flag':
   arch/x86/math-emu/errors.c:539:1: warning: control reaches end of non-void function [-Wreturn-type]
    }
    ^
   arch/x86/math-emu/errors.c: In function 'denormal_operand':
   arch/x86/math-emu/errors.c:569:1: warning: control reaches end of non-void function [-Wreturn-type]
    }
    ^
--
   In file included from arch/x86/math-emu/fpu_aux.c:13:0:
   arch/x86/math-emu/status_w.h: In function 'setcc':
   arch/x86/math-emu/fpu_system.h:71:30: error: request for member 'soft' in something not a structure or union
    #define partial_status  (I387->soft.swd)
                                 ^
   arch/x86/math-emu/status_w.h:53:2: note: in expansion of macro 'partial_status'
     partial_status &= ~(SW_C0 | SW_C1 | SW_C2 | SW_C3);
     ^
   arch/x86/math-emu/fpu_system.h:71:30: error: request for member 'soft' in something not a structure or union
    #define partial_status  (I387->soft.swd)
                                 ^
   arch/x86/math-emu/status_w.h:54:2: note: in expansion of macro 'partial_status'
     partial_status |= (cc) & (SW_C0 | SW_C1 | SW_C2 | SW_C3);
     ^
   arch/x86/math-emu/fpu_aux.c: In function 'fclex':
   arch/x86/math-emu/fpu_system.h:71:30: error: request for member 'soft' in something not a structure or union
    #define partial_status  (I387->soft.swd)
                                 ^
   arch/x86/math-emu/fpu_aux.c:25:2: note: in expansion of macro 'partial_status'
     partial_status &=
     ^
   arch/x86/math-emu/fpu_system.h:64:41: error: request for member 'soft' in something not a structure or union
    #define no_ip_update  (*(u_char *)&(I387->soft.no_update))
                                            ^
   arch/x86/math-emu/fpu_aux.c:29:2: note: in expansion of macro 'no_ip_update'
     no_ip_update = 1;
     ^
   arch/x86/math-emu/fpu_aux.c: In function 'finit':
>> arch/x86/math-emu/fpu_aux.c:55:46: error: request for member 'soft' in something not a structure or union
     fpstate_init_soft(&current->thread.fpu.state.soft);
                                                 ^
   In file included from arch/x86/math-emu/fpu_aux.c:13:0:
   arch/x86/math-emu/fpu_aux.c: In function 'finit_':
   arch/x86/math-emu/fpu_system.h:65:36: error: request for member 'soft' in something not a structure or union
    #define FPU_rm   (*(u_char *)&(I387->soft.rm))
                                       ^
   arch/x86/math-emu/fpu_aux.c:72:15: note: in expansion of macro 'FPU_rm'
     (finit_table[FPU_rm]) ();
                  ^
   arch/x86/math-emu/fpu_aux.c: In function 'fstsw_ax':
   arch/x86/math-emu/fpu_system.h:50:24: error: request for member 'soft' in something not a structure or union
    #define FPU_info  (I387->soft.info)
                           ^
   arch/x86/math-emu/fpu_system.h:55:20: note: in expansion of macro 'FPU_info'
    #define FPU_EAX   (FPU_info->regs->ax)
                       ^
   arch/x86/math-emu/fpu_aux.c:77:13: note: in expansion of macro 'FPU_EAX'
     *(short *)&FPU_EAX = status_word();
                ^
   arch/x86/math-emu/fpu_system.h:71:30: error: request for member 'soft' in something not a structure or union
    #define partial_status  (I387->soft.swd)
                                 ^
   arch/x86/math-emu/status_w.h:50:5: note: in expansion of macro 'partial_status'
      ((partial_status & ~SW_Top & 0xffff) | ((top << SW_Top_Shift) & SW_Top))
        ^
   arch/x86/math-emu/fpu_aux.c:77:23: note: in expansion of macro 'status_word'
     *(short *)&FPU_EAX = status_word();
                          ^
   arch/x86/math-emu/fpu_system.h:75:20: error: request for member 'soft' in something not a structure or union
    #define top   (I387->soft.ftop)
                       ^
   arch/x86/math-emu/status_w.h:50:44: note: in expansion of macro 'top'
      ((partial_status & ~SW_Top & 0xffff) | ((top << SW_Top_Shift) & SW_Top))
                                               ^
   arch/x86/math-emu/fpu_aux.c:77:23: note: in expansion of macro 'status_word'
     *(short *)&FPU_EAX = status_word();
                          ^
   arch/x86/math-emu/fpu_system.h:64:41: error: request for member 'soft' in something not a structure or union
    #define no_ip_update  (*(u_char *)&(I387->soft.no_update))
                                            ^
   arch/x86/math-emu/fpu_aux.c:78:2: note: in expansion of macro 'no_ip_update'
     no_ip_update = 1;
     ^
   arch/x86/math-emu/fpu_aux.c: In function 'fstsw_':
   arch/x86/math-emu/fpu_system.h:65:36: error: request for member 'soft' in something not a structure or union
    #define FPU_rm   (*(u_char *)&(I387->soft.rm))
                                       ^
   arch/x86/math-emu/fpu_aux.c:88:15: note: in expansion of macro 'FPU_rm'
     (fstsw_table[FPU_rm]) ();
                  ^
   arch/x86/math-emu/fpu_aux.c: In function 'fp_nop':
   arch/x86/math-emu/fpu_system.h:65:36: error: request for member 'soft' in something not a structure or union
    #define FPU_rm   (*(u_char *)&(I387->soft.rm))
                                       ^
   arch/x86/math-emu/fpu_aux.c:98:16: note: in expansion of macro 'FPU_rm'
     (fp_nop_table[FPU_rm]) ();
                   ^
   arch/x86/math-emu/fpu_aux.c: In function 'fld_i_':
   arch/x86/math-emu/fpu_system.h:65:36: error: request for member 'soft' in something not a structure or union
    #define FPU_rm   (*(u_char *)&(I387->soft.rm))
                                       ^
   arch/x86/math-emu/fpu_aux.c:113:6: note: in expansion of macro 'FPU_rm'
     i = FPU_rm;
         ^
   arch/x86/math-emu/fpu_system.h:74:25: error: request for member 'soft' in something not a structure or union
    #define registers  (I387->soft.st_space)
                            ^
   arch/x86/math-emu/fpu_emu.h:144:35: note: in expansion of macro 'registers'
    #define register_base ((u_char *) registers )
                                      ^
   arch/x86/math-emu/fpu_emu.h:146:38: note: in expansion of macro 'register_base'
    #define st(x)      ( * ((FPU_REG *)( register_base + 10 * ((top+x) & 7) )) )
                                         ^
   arch/x86/math-emu/fpu_aux.c:115:13: note: in expansion of macro 'st'
      reg_copy(&st(i), st_new_ptr);
                ^
   arch/x86/math-emu/fpu_system.h:75:20: error: request for member 'soft' in something not a structure or union
    #define top   (I387->soft.ftop)
                       ^
   arch/x86/math-emu/fpu_emu.h:146:61: note: in expansion of macro 'top'
    #define st(x)      ( * ((FPU_REG *)( register_base + 10 * ((top+x) & 7) )) )
                                                                ^
   arch/x86/math-emu/fpu_aux.c:115:13: note: in expansion of macro 'st'
      reg_copy(&st(i), st_new_ptr);
                ^
   arch/x86/math-emu/fpu_system.h:75:20: error: request for member 'soft' in something not a structure or union
    #define top   (I387->soft.ftop)
                       ^
   arch/x86/math-emu/fpu_emu.h:156:18: note: in expansion of macro 'top'
    #define push() { top--; }
                     ^
   arch/x86/math-emu/fpu_aux.c:117:3: note: in expansion of macro 'push'
      push();
      ^
   arch/x86/math-emu/fpu_system.h:72:28: error: request for member 'soft' in something not a structure or union
    #define control_word  (I387->soft.cwd)
                               ^
   arch/x86/math-emu/fpu_aux.c:120:7: note: in expansion of macro 'control_word'
      if (control_word & CW_Invalid) {
..

vim +/soft +646 arch/x86/math-emu/fpu_entry.c

^1da177e arch/i386/math-emu/fpu_entry.c Linus Torvalds    2005-04-16  620  		}
^1da177e arch/i386/math-emu/fpu_entry.c Linus Torvalds    2005-04-16  621  	}
^1da177e arch/i386/math-emu/fpu_entry.c Linus Torvalds    2005-04-16  622  }
^1da177e arch/i386/math-emu/fpu_entry.c Linus Torvalds    2005-04-16  623  
ae6af41f arch/x86/math-emu/fpu_entry.c  Tejun Heo         2009-02-09  624  void math_abort(struct math_emu_info *info, unsigned int signal)
^1da177e arch/i386/math-emu/fpu_entry.c Linus Torvalds    2005-04-16  625  {
^1da177e arch/i386/math-emu/fpu_entry.c Linus Torvalds    2005-04-16 @626  	FPU_EIP = FPU_ORIG_EIP;
51e7dc70 arch/x86/math-emu/fpu_entry.c  Srikar Dronamraju 2012-03-12  627  	current->thread.trap_nr = X86_TRAP_MF;
^1da177e arch/i386/math-emu/fpu_entry.c Linus Torvalds    2005-04-16  628  	current->thread.error_code = 0;
^1da177e arch/i386/math-emu/fpu_entry.c Linus Torvalds    2005-04-16  629  	send_sig(signal, current, 1);
^1da177e arch/i386/math-emu/fpu_entry.c Linus Torvalds    2005-04-16  630  	RE_ENTRANT_CHECK_OFF;
^1da177e arch/i386/math-emu/fpu_entry.c Linus Torvalds    2005-04-16  631        __asm__("movl %0,%%esp ; ret": :"g"(((long)info) - 4));
^1da177e arch/i386/math-emu/fpu_entry.c Linus Torvalds    2005-04-16  632  #ifdef PARANOID
^1da177e arch/i386/math-emu/fpu_entry.c Linus Torvalds    2005-04-16  633  	printk("ERROR: wm-FPU-emu math_abort failed!\n");
^1da177e arch/i386/math-emu/fpu_entry.c Linus Torvalds    2005-04-16  634  #endif /* PARANOID */
^1da177e arch/i386/math-emu/fpu_entry.c Linus Torvalds    2005-04-16  635  }
^1da177e arch/i386/math-emu/fpu_entry.c Linus Torvalds    2005-04-16  636  
c47ada30 arch/x86/math-emu/fpu_entry.c  Ingo Molnar       2015-04-30  637  #define S387 ((struct swregs_state *)s387)
^1da177e arch/i386/math-emu/fpu_entry.c Linus Torvalds    2005-04-16  638  #define sstatus_word() \
^1da177e arch/i386/math-emu/fpu_entry.c Linus Torvalds    2005-04-16  639    ((S387->swd & ~SW_Top & 0xffff) | ((S387->ftop << SW_Top_Shift) & SW_Top))
^1da177e arch/i386/math-emu/fpu_entry.c Linus Torvalds    2005-04-16  640  
ff0ebb23 arch/x86/math-emu/fpu_entry.c  Roland McGrath    2008-01-30  641  int fpregs_soft_set(struct task_struct *target,
ff0ebb23 arch/x86/math-emu/fpu_entry.c  Roland McGrath    2008-01-30  642  		    const struct user_regset *regset,
ff0ebb23 arch/x86/math-emu/fpu_entry.c  Roland McGrath    2008-01-30  643  		    unsigned int pos, unsigned int count,
ff0ebb23 arch/x86/math-emu/fpu_entry.c  Roland McGrath    2008-01-30  644  		    const void *kbuf, const void __user *ubuf)
^1da177e arch/i386/math-emu/fpu_entry.c Linus Torvalds    2005-04-16  645  {
c47ada30 arch/x86/math-emu/fpu_entry.c  Ingo Molnar       2015-04-30 @646  	struct swregs_state *s387 = &target->thread.fpu.state.soft;
ff0ebb23 arch/x86/math-emu/fpu_entry.c  Roland McGrath    2008-01-30  647  	void *space = s387->st_space;
ff0ebb23 arch/x86/math-emu/fpu_entry.c  Roland McGrath    2008-01-30  648  	int ret;
^1da177e arch/i386/math-emu/fpu_entry.c Linus Torvalds    2005-04-16  649  	int offset, other, i, tags, regnr, tag, newtop;

:::::: The code at line 646 was first introduced by commit
:::::: c47ada305de3803517ae64aa50686f644c5456fa x86/fpu: Harmonize FPU register state types

:::::: TO: Ingo Molnar <mingo@kernel.org>
:::::: CC: Ingo Molnar <mingo@kernel.org>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--KsGdsel6WgEHnImy
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--KsGdsel6WgEHnImy--
