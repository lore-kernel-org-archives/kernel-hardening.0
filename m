Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <5879F762.32059.37092152@pageexec.freemail.hu>
References: <20170113220256.GA57663@beast> <5879F762.32059.37092152@pageexec.freemail.hu>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 17 Jan 2017 09:48:46 -0800
Message-ID: <CAGXu5jLuw-EgB8gpVsHwyYrVaa6Q3mt0tezMT6MkmWe7WHVeFA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] gcc-plugins: Add structleak for more stack initialization
To: PaX Team <pageexec@freemail.hu>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Emese Revfy <re.emese@gmail.com>, "AKASHI, Takahiro" <takahiro.akashi@linaro.org>, Mark Rutland <mark.rutland@arm.com>, park jinbum <jinb.park7@gmail.com>, Daniel Micay <danielmicay@gmail.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Jan 14, 2017 at 2:03 AM, PaX Team <pageexec@freemail.hu> wrote:
> On 13 Jan 2017 at 14:02, Kees Cook wrote:
>
>> This plugin detects any structures that contain __user attributes and
>> makes sure it is being fulling initialized so that a specific class of
>> information exposure is eliminated. (For example, the exposure of siginfo
>> in CVE-2013-2141 would have been blocked by this plugin.)
>
> why the conditional? the plugin was specifically written to block that bug
> and block it did ;).

I can rephrase this. I just wanted to give an example. How about:

 This plugin detects any structures that contain __user attributes and
 makes sure it is being fulling initialized so that a specific class of
 information exposure is eliminated. (This plugin was originally
 designed to block the exposure of siginfo in CVE-2013-2141.)

>> +config GCC_PLUGIN_STRUCTLEAK
>> +     bool "Force initialization of variables containing userspace addresses"
>> +     depends on GCC_PLUGINS
>> +     help
>> +       This plugin zero-initializes any structures that containing a
>> +       __user attribute. This can prevent some classes of information
>> +       exposures.
>
> i see that you completely ditched the description in PaX, is there a reason
> for it?

Yup, details below...

I didn't use the "bool" text because it wasn't accurate:

        bool "Forcibly initialize local variables copied to userland"

This implies "all", but it's not, and it has nothing to do with stuff
copied to userland. It's just looking a __user, with no examination of
copy_to_user() calls.

The rest:

          By saying Y here the kernel will zero initialize some local
          variables that are going to be copied to userland.  This in

Like the bool text, this isn't accurate. I can be specific about the
"some", but the "copied to userland" just isn't true.

          turn prevents unintended information leakage from the kernel
          stack should later code forget to explicitly set all parts of
          the copied variable.

I could reuse this part, sure. I tend to like to use the term
"exposure" instead of "leak", though, so at this point I just rewrote
the description of the "why".

          The tradeoff is less performance impact than PAX_MEMORY_STACKLEAK
          at a much smaller coverage.

I left this out because upstream doesn't have STACKLEAK to compare against yet.

          Note that the implementation requires a gcc with plugin support,
          i.e., gcc 4.5 or newer.  You may need to install the supporting
          headers explicitly in addition to the normal gcc package.

I left this out because it's redundant with the description of
CONFIG_GCC_PLUGINS.

> your text isn't correct as is because
>
> - the __user attribute (which is an implementation choice, see below) doesn't
>   apply to structures but pointers only (as it does for sparse IIRC)
> - a structure is a type, but the plugin initializes variables, not types
>   (the latter makes little sense)
> - the plugin doesn't initialize 'any structures' (well, variables), only locals
>   and only at function scope (subject to further evolution as discussed earlier).

Including mention of "__user" in Kconfig help text is already a bit
"too technical", so I was trying to be concise. I could easily expand
this to "any structure variables with __user pointers in function
scope", but it seemed like unneeded details. (This level of detail
isn't present in the PaX Kconfig either...)

>> +config GCC_PLUGIN_STRUCTLEAK_VERBOSE
>> +     bool "Report initialized variables"
>> +     depends on GCC_PLUGIN_STRUCTLEAK
>> +     depends on !COMPILE_TEST
>> +     help
>> +       This option will cause a warning to be printed each time the
>> +       structleak plugin finds a variable it thinks needs to be
>> +       initialized. Since not all existing initializers are detected
>> +       by the plugin, this can produce false positive warnings.
>
> there are no false positives, a variable either has a constructor or it does not ;)

Well, as pointed out, there are plenty of false positives where the
plug reports the need to initialize the variable when it doesn't. It
doesn't report that it's missing a constructor. :) This is a pragmatic
description of what is happening, and since the plugin does sometimes
needlessly insert initializations where none are needed, that really
seems like a false positive to me. :)

>> +/* unused C type flag in all versions 4.5-6 */
>> +#define TYPE_USERSPACE(TYPE) TYPE_LANG_FLAG_5(TYPE)
>
> FYI, this is a sort of abuse/hack of tree flags and should not be implemented this
> way in the upstream kernel as it's a finite resource and needs careful verification
> against all supported gcc versions (these flags are meant for language fronteds, i
> kinda got lucky to have a few of them unusued but it's not a robust future-proof
> approach). instead an attribute should be used to mark these types. whether that
> can/should be __user itself is a good question since that's another hack where the
> plugin 'hijacks' a sparse address space atttribute (for which gcc 4.6+ has its own
> facilities and that the checker gcc plugin makes use of thus it's not compatible
> with structleak as is).

Yeah, I wasn't too happy about that lang flag usage either. It seems
reasonable to just build an attribute on the fly. IIRC, initify does
this already to mark things it has already processed?

-Kees

-- 
Kees Cook
Nexus Security
