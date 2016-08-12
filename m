Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 12 Aug 2016 11:23:23 +0200 (CEST)
From: Jiri Kosina <jikos@kernel.org>
In-Reply-To: <alpine.LNX.2.00.1608120800100.22028@cbobk.fhfr.pm>
Message-ID: <alpine.LNX.2.00.1608121044120.22028@cbobk.fhfr.pm>
References: <1470952169-39061-1-git-send-email-thgarnie@google.com> <alpine.LNX.2.00.1608120800100.22028@cbobk.fhfr.pm>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH v1] x86/power/64: Restore processor state before using
 per-cpu variables
To: Thomas Garnier <thgarnie@google.com>
Cc: "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, keescook@chromium.org, kernel-hardening@lists.openwall.com, bpetkov@suse.de, yinghai@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 12 Aug 2016, Jiri Kosina wrote:

> One thing is still beyond me though ... how the heck this doesn't happen 
> without DEBUG_LOCK_ALLOC? The percpu area pointer should be corrupted 
> nevertheless, shouldn't it?

The reason is that turning DEBUG_LOCK_ALLOC changing 
trace_suspend_resume() from

ffffffff810c7280 <trace_suspend_resume>:
ffffffff810c7280:       55                      push   %rbp
ffffffff810c7281:       48 89 e5                mov    %rsp,%rbp
ffffffff810c7284:       41 56                   push   %r14
ffffffff810c7286:       41 55                   push   %r13
ffffffff810c7288:       41 54                   push   %r12
ffffffff810c728a:       53                      push   %rbx
ffffffff810c728b:       0f 1f 44 00 00          nopl   0x0(%rax,%rax,1)
ffffffff810c7290:       65 8b 05 59 2f f4 7e    mov    %gs:0x7ef42f59(%rip),%eax        # a1f0 <cpu_number>
ffffffff810c7297:       89 c0                   mov    %eax,%eax
ffffffff810c7299:       48 0f a3 05 9f 2f c4    bt     %rax,0xc42f9f(%rip)        # ffffffff81d0a240 <__cpu_online_mask>

to

ffffffff810ad150 <trace_suspend_resume>:
ffffffff810ad150:       0f 1f 44 00 00          nopl   0x0(%rax,%rax,1)
ffffffff810ad155:       c3                      retq   
ffffffff810ad156:       65 8b 05 93 d0 f5 7e    mov    %gs:0x7ef5d093(%rip),%eax        # a1f0 <cpu_number>
ffffffff810ad15d:       89 c0                   mov    %eax,%eax
ffffffff810ad15f:       48 0f a3 05 59 0b c4    bt     %rax,0xc40b59(%rip)        # ffffffff81cedcc0 <__cpu_online_mask>
ffffffff810ad166:       00

IOW, with the config change, trace_suspend_resume() returns immediately 
without trying to get the current SMP id. And it's because of 
DEBUG_LOCK_ALLOC implies LOCKDEP, and that does this to __DECLARE_TRACE()

	 * When lockdep is enabled, we make sure to always do the RCU portions of
	 * the tracepoint code, regardless of whether tracing is on. However,
	 * don't check if the condition is false, due to interaction with idle
	 * instrumentation. This lets us find RCU issues triggered with tracepoints
	 * even when this tracepoint is off. This code has no purpose other than
	 * poking RCU a bit.
	 */
	#define __DECLARE_TRACE(name, proto, args, cond, data_proto, data_args) \
		extern struct tracepoint __tracepoint_##name;                   \
		static inline void trace_##name(proto)                          \
		{                                                               \
			if (static_key_false(&__tracepoint_##name.key))         \
				__DO_TRACE(&__tracepoint_##name,                \
					TP_PROTO(data_proto),                   \
					TP_ARGS(data_args),                     \
					TP_CONDITION(cond),,);                  \
			if (IS_ENABLED(CONFIG_LOCKDEP) && (cond)) {             \
				rcu_read_lock_sched_notrace();                  \
				rcu_dereference_sched(__tracepoint_##name.funcs);\
				rcu_read_unlock_sched_notrace();                \
			}                                                       \
		} 

That's pretty nasty, as turning LOCKDEP on has sideffects on the code 
that'd normally not be expected to be run at all (tracepoint off).

Oh well.

Thanks again,

-- 
Jiri Kosina
SUSE Labs
