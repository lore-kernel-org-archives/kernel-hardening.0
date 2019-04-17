Date: Wed, 17 Apr 2019 17:16:18 +0200
From: Jessica Yu <jeyu@kernel.org>
Subject: Re: [PATCH v3 3/3] module: Make __tracepoints_ptrs as read-only
Message-ID: <20190417151618.GD17099@linux-8ccs>
References: <20190410195708.162185-1-joel@joelfernandes.org>
 <20190410195708.162185-3-joel@joelfernandes.org>
 <20190410161112.540017d9@gandalf.local.home>
 <20190410202902.GA167446@google.com>
 <20190410204401.62f928ca@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190410204401.62f928ca@gandalf.local.home>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Joel Fernandes <joel@joelfernandes.org>, linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, keescook@chromium.org, mathieu.desnoyers@efficios.com, kernel-hardening@lists.openwall.com, kernel-team@android.com, rcu@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

+++ Steven Rostedt [10/04/19 20:44 -0400]:
>On Wed, 10 Apr 2019 16:29:02 -0400
>Joel Fernandes <joel@joelfernandes.org> wrote:
>
>> The srcu structure pointer array is modified at module load time because the
>> array is fixed up by the module loader at load-time with the final locations
>> of the tracepoints right?  Basically relocation fixups. At compile time, I
>> believe it is not know what the values in the ptr array are. I believe same
>> is true for the tracepoint ptrs array.
>>
>> Also it needs to be in a separate __tracepoint_ptrs so that this code works:
>>
>>
>> #ifdef CONFIG_TRACEPOINTS
>> 	mod->tracepoints_ptrs = section_objs(info, "__tracepoints_ptrs",
>> 					     sizeof(*mod->tracepoints_ptrs),
>> 					     &mod->num_tracepoints);
>> #endif
>>
>> Did I  miss some point? Thanks,
>
>But there's a lot of others too. Hmm, does this mean that the RO data
>sections that are in modules are not set to RO?
>
>There's a bunch of separate sections that are RO. Just look in
>include/asm-generic/vmlinux.lds.h under the RO_DATA_SECTION() macro.
>
>A lot of the sections saved in module.c:find_module_sections() are in
>that RO_DATA when compiled as a builtin. Are they not RO when loaded via
>a module?

Unlike the kernel, the module loader does not rely on a linker script
to determine which sections get what protections. On module load, all
sections in a module are looped through and those sections without the
SHF_WRITE flag will be set to RO. For example, when there is a section
filled with structs declared as const or if the section was explicitly
given only the SHF_ALLOC attribute, those will be read-only. As long
as the sections were given the correct section attributes for
read-only, it'll have read-only protection. I see this is already the
case for __param and  __ksymtab*/__kcrctab* sections, but I agree that
a full audit would be useful to be consistent with builtin RO
protections.

Hope that helps,

Jessica
