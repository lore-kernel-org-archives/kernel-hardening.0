Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20151106235545.97d0e86a5f1f80c98e0e9de6@gmail.com>
References: <20151106235545.97d0e86a5f1f80c98e0e9de6@gmail.com>
Date: Fri, 6 Nov 2015 15:30:39 -0800
Message-ID: <CAGXu5jK2boq=rSwrdyqyq=B_kZJR2pUQe99+tPBwK+pKEx0X+w@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: Proposal for kernel self protection features
To: Emese Revfy <re.emese@gmail.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Greg KH <gregkh@linuxfoundation.org>, Theodore Tso <tytso@google.com>, Josh Triplett <josh@joshtriplett.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Nov 6, 2015 at 2:55 PM, Emese Revfy <re.emese@gmail.com> wrote:
> Hi,
>
> My name is Emese Revfy, the author of the size_overflow, initify gcc plugin
> and the original creator of the constify gcc plugin in grsecurity/PaX.
>
> I'm very happy about this Kernel Self Protection Project and
> I'd like to take part in it.

Welcome! Your participation would be extremely valuable. :)

> I can do the following tasks:
>  * gcc plugin infrastructure
>  * size_overflow: Briefly about the plugin, it recomputes expressions
>     that are marked by a size_overflow attribute or which are in the hash table
>     with double integer precision. The recomputed expression is checked against
>     TYPE_MIN/TYPE_MAX in the end and during some casts.
>     It needs three hash tables:
>     * size_overflow_hash: This hash table stores functions, function pointers,
>        structure fields and variable declarations for the size_overflow
>        duplication. It must be regenerated for every kernel version.
>     * disable_size_overflow_hash: We ignore (don't instrument) the functions
>        in this hash table.
>     * size_overflow_hash_aux: For out-of-tree modules.

By out-of-tree, you mean built-out-of-tree? I assume a future
downstream kernel that used size_overflow would have their
non-upstream code covered during the size_overflow_hash regeneration?
(Though they'd be on the their own for handling the false positives.)

>     The non-public version of the plugin also supports LTO so when the kernel
>     will support LTO then hash tables will no longer be needed.
>     There are three kinds of false positives that are caused by:
>        * the developers: some code uses integer overflow for no reason.
>           These can be fixed in the source code.
>        * the developers intentionally: usually in the net part of the
>           kernel (counters etc.). We use an gcc attribute (intentional_overflow)
>           to ignore these functions.
>        * gcc intentional overflow: gcc computes some expressions by overflow
>           when it optimizes. Sadly it is doing this in the front end where
>           there is no plugin support. Most of these false positives I handle
>           from the plugin or sometimes I patch the kernel source code.
>           There are some unsolved issues.

Has there been any discussion with gcc folks about this problem?

>     You can read more about the plugin:
>     https://forums.grsecurity.net/viewtopic.php?f=7&t=3043
>     This is a complex plugin and it has false positives but it also found
>     a lot of bugs (overflows, underflows and trunctions) and
>     thanks to the data flow duplication it has a small performance impact only.
>     I know that I will have to adapt it to be suitable for vanilla.

That's a great write-up! I would call other people's attention to the
portion where you point out it blocks real-world cases of flaws:
CVE-2013-0914 CVE-2013-0913 CVE-2013-2141

>  * constify: This plugin constifies all structure types which contain only
>     function pointers or are explicitly marked for constification.
>     If some code wants to modify a read-only object it will cause
>     a compile error.
>     There are two gcc attributes:
>        * no_const: if we don't want constification
>        * do_const: if we want to constify a structure type which has a
>           non-function pointer field

I assume some level of no_const marking could go away when KERNEXEC or
at least a similar "temporary writing" ability lands in upstream?

>  * latent_entropy: This plugin generates some entropy from program state
>     throughout the uptime of the kernel. It has small performance loss.
>     The plugin uses an attribute which can be
>     on a function (to extract entropy beyond init functions) or on a
>     variable (to initialize it with a random number generated at compile time)

How large is the entropy extracted during early init? I bet a lot of
architectures would rejoice to have this available. (CCing Ted for
thoughts.)

>  * structleak: This plugin forcibly initializes certain local variables
>     based on the __user attribute that could otherwise leak kernel stack
>     to userland if they aren't properly initialized by later code.
>     It has small performance loss.

Does this operate only on kernel stack structures?

>  * colorize: This plugin is just for fun, it isn't a security related plugin.
>     If the gcc version doesn't support colors (before gcc-4.9) then
>     it colorizes the compiler output.

Hah, nice. :)

>  * initify: This plugin isn't security related either.
>     It moves string constants (__func__ and function string arguments
>     marked by the nocapture attribute) only referenced in
>     __init/__exit functions to __initconst/__exitconst sections.
>     It reduces memory usage (many kB), I think it may be important for
>     embedded systems.

I bet the Tinification project ( https://tiny.wiki.kernel.org/ ) would
be interested in this! (CCing Josh for thoughts.)

> I think the first plugin can be a simpler plugin e.g., constify or latent_entropy.
> Please let me know if you want one, more or all of them.

Well I would love to see all of them upstream. :) As for first steps,
you've convinced me about the complexity of the size_overflow plugin.
Perhaps the constify plugin would be a good first target? Can you
speak to any known bugs it stopped? Having some mention of the threat
it mitigates would be helpful. (Do I remember correctly that it
constified security_operations, which was a common target in
exploits?)

Thanks very much!

-Kees

-- 
Kees Cook
Chrome OS Security
