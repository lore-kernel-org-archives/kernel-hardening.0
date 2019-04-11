Date: Thu, 11 Apr 2019 04:21:06 -0400
From: Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH v3 3/3] module: Make __tracepoints_ptrs as read-only
Message-ID: <20190411082106.GB167446@google.com>
References: <20190410195708.162185-1-joel@joelfernandes.org>
 <20190410195708.162185-3-joel@joelfernandes.org>
 <20190410161112.540017d9@gandalf.local.home>
 <20190410202902.GA167446@google.com>
 <20190410204401.62f928ca@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190410204401.62f928ca@gandalf.local.home>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, keescook@chromium.org, mathieu.desnoyers@efficios.com, Jessica Yu <jeyu@kernel.org>, kernel-hardening@lists.openwall.com, kernel-team@android.com, rcu@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Apr 10, 2019 at 08:44:01PM -0400, Steven Rostedt wrote:
> On Wed, 10 Apr 2019 16:29:02 -0400
> Joel Fernandes <joel@joelfernandes.org> wrote:
> 
> > The srcu structure pointer array is modified at module load time because the
> > array is fixed up by the module loader at load-time with the final locations
> > of the tracepoints right?  Basically relocation fixups. At compile time, I
> > believe it is not know what the values in the ptr array are. I believe same
> > is true for the tracepoint ptrs array.
> > 
> > Also it needs to be in a separate __tracepoint_ptrs so that this code works:
> > 
> > 
> > #ifdef CONFIG_TRACEPOINTS
> > 	mod->tracepoints_ptrs = section_objs(info, "__tracepoints_ptrs",
> > 					     sizeof(*mod->tracepoints_ptrs),
> > 					     &mod->num_tracepoints);
> > #endif
> > 
> > Did I  miss some point? Thanks,
> 
> But there's a lot of others too. Hmm, does this mean that the RO data
> sections that are in modules are not set to RO?
> 
> There's a bunch of separate sections that are RO. Just look in
> include/asm-generic/vmlinux.lds.h under the RO_DATA_SECTION() macro.
> 
> A lot of the sections saved in module.c:find_module_sections() are in
> that RO_DATA when compiled as a builtin. Are they not RO when loaded via
> a module?
> 
> If this is the case, there probably is going to be a lot more sections
> added to your list.

Hi Steven,

You are right. It turns out that this patch for tracepoint is not needed
since each tracepoint pointer is marked as a const which automatically makes
the section non-writable after relocations..

#ifdef CONFIG_HAVE_ARCH_PREL32_RELOCATIONS
typedef const int tracepoint_ptr_t;
#else
typedef struct tracepoint * const tracepoint_ptr_t;
#endif

So the fix for SRCU could just be the following. I verified with the change
that the ELF section section is marked only with the ALLOCATE flag, not the
WRITE flag which should automatically put the srcu pointer array in rodata.
I'll test this out tomorrow.

Patch 2/3 and 3/3 would not be nececessary if this works out. 1/3 may be a
nice clean up but is not something urgent and we could do that in the future
if needed.

Any thoughts? Thanks a lot for the review!

(I believe it is still worth auditing other sections in built-in RODATA and
making sure they are non-writable for modules as well).

---8<-----------------------

diff --git a/include/linux/srcutree.h b/include/linux/srcutree.h
index 8af1824c46a8..9cfcc8a756ae 100644
--- a/include/linux/srcutree.h
+++ b/include/linux/srcutree.h
@@ -123,7 +123,7 @@ struct srcu_struct {
 #ifdef MODULE
 # define __DEFINE_SRCU(name, is_static)					\
 	is_static struct srcu_struct name;				\
-	struct srcu_struct *__srcu_struct_##name			\
+	struct srcu_struct * const __srcu_struct_##name			\
 		__section("___srcu_struct_ptrs") = &name
 #else
 # define __DEFINE_SRCU(name, is_static)					\
