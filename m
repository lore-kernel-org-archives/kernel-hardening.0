Subject: Re: Investigating a stack state mismatch in Linux kernel
From: Alexander Popov <alex.popov@linux.com>
References: <b7aad232-76e1-241f-00e2-77783ce30f87@linux.com>
 <875zwyabac.fsf@oldenburg.str.redhat.com>
 <2a2b1181-2175-7e4e-189c-12630f43d10d@linux.com>
Message-ID: <57225f38-3f6d-4029-8f89-4b6eba97c3c1@linux.com>
Date: Wed, 21 Nov 2018 02:08:29 +0300
MIME-Version: 1.0
In-Reply-To: <2a2b1181-2175-7e4e-189c-12630f43d10d@linux.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Florian Weimer <fweimer@redhat.com>, Richard Sandiford <richard.sandiford@arm.com>, Segher Boessenkool <segher@kernel.crashing.org>, Alexander Monakov <amonakov@ispras.ru>
Cc: Kees Cook <keescook@chromium.org>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Tycho Andersen <tycho@tycho.ws>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Emese Revfy <re.emese@gmail.com>, Thomas Garnier <thgarnie@google.com>, Alexei Starovoitov <ast@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>, "David S . Miller" <davem@davemloft.net>, Steven Rostedt <rostedt@goodmis.org>, Dave Hansen <dave.hansen@linux.intel.com>, Will Deacon <will.deacon@arm.com>, Jann Horn <jannh@google.com>, linux-arm-kernel@lists.infradead.org, gcc-bugs@gcc.gnu.org, gcc-help@gcc.gnu.org, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, gcc@gcc.gnu.org
List-ID: <kernel-hardening.lists.openwall.com>

Hello everyone!

At irc.freenode.org/#gcc people told me that I should CC gcc@gcc.gnu.org to get
some attention of gcc developers.

Link to previous discussion:
 https://www.openwall.com/lists/kernel-hardening/2018/11/14/1


On 15.11.2018 23:51, Alexander Popov wrote:
> In the original grsecurity code the stackleak RTL pass was registered just
> before the 'rtl-final' pass. Some time ago Richard Sandiford noted that:
> 
>>>> This might be too late, since it happens e.g. after addresses have
>>>> been calculated for branch ranges, and after machine-specific passes
>>>> (e.g. bundling on ia64).
>>>>
>>>> The stack size is final after reload, so inserting the pass after that
>>>> might be better.
> 
> https://lore.kernel.org/patchwork/patch/879912/
> 
> So what is the best moment when we know the stack frame size and can safely
> delete the CALL insn using delete_insn_and_edges()?

At irc.oftc.net/#gcc Segher (kudos to him!) confirmed that 'final' pass is too
late for this and proposed registering 'stackleak_cleanup' pass before
'machine_reorg' pass. It's the moment when the stack frame size is already final
and function prologues and epilogues are generated. That would also fit
Richard's concerns.

It looks reasonable -- that's what gcc/target.def says about
machine_dependent_reorg() hook, which is called during 'machine_reorg' pass:

"If non-null, this hook performs a target-specific pass over the
instruction stream. The compiler will run it at all optimization levels,
just before the point at which it normally does delayed-branch scheduling.
The exact purpose of the hook varies from target to target.  Some use
it to do transformations that are necessary for correctness, such as
laying out in-function constant pools or avoiding hardware hazards.
Others use it as an opportunity to do some machine-dependent optimizations".


So I would appreciate any comments on the following solution:

diff --git a/scripts/gcc-plugins/stackleak_plugin.c
b/scripts/gcc-plugins/stackleak_plugin.c
index 2f48da9..6f41b32 100644
--- a/scripts/gcc-plugins/stackleak_plugin.c
+++ b/scripts/gcc-plugins/stackleak_plugin.c
@@ -363,10 +363,12 @@ __visible int plugin_init(struct plugin_name_args
*plugin_info,
                                                PASS_POS_INSERT_BEFORE);

        /*
-        * The stackleak_cleanup pass should be executed after the
-        * "reload" pass, when the stack frame size is final.
+        * The stackleak_cleanup pass should be executed before the "mach"
+        * pass, which performs the machine dependent code transformations.
+        * It's the moment when the stack frame size is already final and
+        * function prologues and epilogues are generated.
         */
-       PASS_INFO(stackleak_cleanup, "reload", 1, PASS_POS_INSERT_AFTER);
+       PASS_INFO(stackleak_cleanup, "mach", 1, PASS_POS_INSERT_BEFORE);

        if (!plugin_default_version_check(version, &gcc_version)) {
                error(G_("incompatible gcc/plugin versions"));
