MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170203101949.4c6908be@kaiwan-T460>
References: <20170118095155.5e3bf976@kaiwan-T460> <90224a2d-2bfc-8c1e-1f2c-ca5bfbdb4879@redhat.com>
 <20170203101949.4c6908be@kaiwan-T460>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 3 Feb 2017 16:23:32 -0800
Message-ID: <CAGXu5jLUdxDkjZ8Qndui1=5LC-_eavCpsgAqRa7RbdBUVdSsEg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Merge in PAX_MEMORY_SANITIZE work from grsec
 to linux-next
To: Kaiwan N Billimoria <kaiwan@kaiwantech.com>
Cc: Laura Abbott <labbott@redhat.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Feb 2, 2017 at 8:49 PM, Kaiwan N Billimoria
<kaiwan@kaiwantech.com> wrote:
> Pl bear with me, am trying to understand this correctly.

No problem at all. Thanks for continuing to poke at this. :)

> From what I gather, we look to create a new config directive, say,
> CONFIG_MEMORY_SANITIZE .
>
> It will turn ON :
>  CONFIG_DEBUG_PAGEALLOC
>    (which internally turns ON CONFIG_PAGE_EXTENSION), and
>  CONFIG_PAGE_POISONING
>    (similar internal turn-ons :).

I think CONFIG_MEMORY_SANITIZE would enable:

CONFIG_SLUB_DEBUG=y
CONFIG_PAGE_POISONING=y
CONFIG_PAGE_POISONING_NO_SANITY=y

but it would _also_ need to set these kernel command-line variables as
if they had been set:

page_poison=1
slub_debug=P

> The new config now enables the CONFIG_PAX_MEMORY_SANITIZE code (my prev
> email patch), correct? (leaving out the stuff we cannot get without the
> full grsec implementation).

No, the first step would be for the config to only provide the above changes.

Then, we'd want to add the poison value defaults as you mention:

> -Would include the 'new' poison / sanitize values of 0xfe and 0xff for slab
> (64 and 32-bit resp), etc etc.

And then finally add the exceptions for the "frequently freed" slub
caches, as identified by PaX already. This would need the flag
defined, the poisoning logic adjusted to check the flag, and for the
new kernel command-line options for changing the whether or not the
flag is respected (like PaX's "pax_sanitize_slab").

> Even if this is (somewhat) correct, my thinking is - correct me I'm totally
> wrong here - that the whole purpose of the exercise is to improve _security_;
> hence, tying this code into the "debug features" of the kernel isn't really
> what we want, yes?

In the discussions Laura had with the mm folks, the only realistic
path to landing this in the upstream kernel is through these debug
features.

> Most folks would only use debug during development, if at all - given all the
> concerns regarding performance. Here, the objective is to enable a powerful
> security feature set. Hence, the config directives should come under the
> 'Security Options' menu.

We're not close to having a "Kernel Security" menu, so for now, I've
wanted to focus on getting the features, and then making the Kconfig
menus pretty later.

Hopefully that all makes sense! :)

-Kees

-- 
Kees Cook
Pixel Security
