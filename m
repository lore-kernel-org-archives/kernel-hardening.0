Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <56E95670.32699.2E48F0FA@pageexec.freemail.hu>
References: <20160307000208.1bec3e7dc874489d1b4fcbb4@gmail.com>
	<56E72C58.28997.25D483C7@pageexec.freemail.hu>
	<CAK7LNAQjjTdkO454bL9h=ad_LzCnW_s4qO9gJmOUvVCH_1b+GQ@mail.gmail.com>
	<56E95670.32699.2E48F0FA@pageexec.freemail.hu>
Date: Thu, 17 Mar 2016 13:09:37 +0900
Message-ID: <CAK7LNATU+zh7PR6LJz6nX8grrWy55wHrikSAVStCvhspH7gnCw@mail.gmail.com>
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v5 2/5] GCC plugin infrastructure
To: pageexec@freemail.hu
Cc: Emese Revfy <re.emese@gmail.com>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, spender@grsecurity.net, kernel-hardening@lists.openwall.com, Michal Marek <mmarek@suse.com>, Kees Cook <keescook@chromium.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, fengguang.wu@intel.com, Dmitry Vyukov <dvyukov@google.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

2016-03-16 21:49 GMT+09:00 PaX Team <pageexec@freemail.hu>:
> On 16 Mar 2016 at 16:34, Masahiro Yamada wrote:
>
> Hi,
>
>> >> As mentioned above, I want you to use "..." style
>> >> when you need to use relative path from the source.
>> >>
>> >> I do not see most of them in tools/gcc/.
>> >
>> > no, that'd be incorrect for several reasons. first, the rule to use <...> vs. "..."
>> > include directives is not about the header being in the same directory but whether
>> > the header is a system header or one provided by the given program. roughly speaking,
>> > system headers are those that are available through the compiler's default include
>> > paths (gcc's own headers, those of glibc and other libraries under /usr/include, etc).
>> > gcc plugin headers are *not* available by default, one has to query the compiler about
>> > their path (see -print-file-name=plugin above) and explicitly add it to the compiler's
>> > include search path.
>>
>> Are you sure?
>
> sure about which part? ;)

You said "that'd be incorrect", but
there is no "correct" or "incorrect" in either way as long as it works.

This decision varies from project to project.

At least in Linux, it generally uses #include <file> style
except ones in local directories.
I guess it is debatable if this rule also applies to host tools or not.


> the use of <...> vs "..." is a matter of convention (to
> differentiate between 'system' headers from the program's own) and for gcc the plugin
> headers don't count as 'system' headers, gcc uses "..." throughout its codebase itself
> (so does clang/llvm). it'd look weird and inconsistent if compiler plugins used <...>.
>
> at the end of the day this comes down to whether gcc plugins are considered kernel
> code and thus the kernel style applies to them (the kernel itself uses <...> because
> it's a freestanding program so its 'system' headers are mostly what it provides
> itself, not those of the compiler let alone userland libs) or gcc extensions and thus
> the gcc include style applies to them. as you can guess, i'm arguing for the latter,
> because gcc plugins are meant for the compiler, not the kernel per se, and in fact
> we have several plugins already that can be used in userland as well (e.g., Emese's
> size overflow plugin).
>
> the one thing for plugins that i borrowed from the kernel instead of gcc is the code
> formatting style as the GNU one is as bad as Linus argued decades ago ;).
>
>> > second, regardless of whether plugin headers are available by default or not, we
>> > still couldn't use them during cross-compilation as the plugin headers we want are
>> > those of the target compiler (that will load the plugin eventually), not that of
>> > the host compiler (which merely compiles the plugin and in theory doesn't even have
>> > to be gcc or a plugin capable gcc).
>>
>> So, how could this be the reason why we should avoid #include <file>?
>
> because <...> is meant for headers that are on the compiler's default search path
> and even if gcc plugin headers were there (they aren't) they'd be the wrong ones
> to use, you'd have to specifically override the include path with that of the target
> compiler which is a sign that you're no longer including 'system' headers (again,
> this convention holds for hosted programs, freestanding ones don't have anything
> but 'system' headers usually).
>
>> > for these reasons the correct include directive is "..." and not <...>. if it helps
>> > to understand the situation better, consider that gcc plugins are to gcc as kernel
>> > modules are to vmlinux and all kernel headers are included via "..." as well, regardless
>                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> sorry, i take that back, the kernel uses <...> but for a reason that in my opinion
> doesn't apply to compiler plugins (see above).
>
>> > of whether they're in the same directory or not.
>>
>> Of course, you could use #include "..." as well to include kernel headers,
>> but you should not do that.
>>
>> You should do so only when you need to include headers that are local
>> to your directory.
>
> sure, a header in the same directory is a sign that it's not a 'system' header but
> i'm also saying that there can be other non-system headers in a program in other
> directories as well. FWIW, the kernel itself has several "..." directives that
> reference headers outside of the same directory, e.g., try this in a kernel tree:
>
>   grep "#include.*\"\." -rn
>

To sum up, your suggestion for GCC plugins is

  - Use #include <...> to include header files provided by the host compiler
  - Use #include "..." to include header files provided by the cross
compiler (plugin directory)
  - Use #include "..." to include header files in the local project

Correct?

I leave the final decision to others.


-- 
Best Regards
Masahiro Yamada
