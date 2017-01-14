Reply-To: kernel-hardening@lists.openwall.com
From: "PaX Team" <pageexec@freemail.hu>
Date: Sat, 14 Jan 2017 11:03:14 +0100
MIME-Version: 1.0
Message-ID: <5879F762.32059.37092152@pageexec.freemail.hu>
In-reply-to: <20170113220256.GA57663@beast>
References: <20170113220256.GA57663@beast>
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Subject: [kernel-hardening] Re: [PATCH] gcc-plugins: Add structleak for more stack initialization
To: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>
Cc: Emese Revfy <re.emese@gmail.com>, "AKASHI, Takahiro" <takahiro.akashi@linaro.org>, Mark Rutland <mark.rutland@arm.com>, park jinbum <jinb.park7@gmail.com>, Daniel Micay <danielmicay@gmail.com>, linux-kernel@vger.kernel.org, spender@grsecurity.net
List-ID: <kernel-hardening.lists.openwall.com>

On 13 Jan 2017 at 14:02, Kees Cook wrote:

> This plugin detects any structures that contain __user attributes and
> makes sure it is being fulling initialized so that a specific class of
> information exposure is eliminated. (For example, the exposure of siginfo
> in CVE-2013-2141 would have been blocked by this plugin.)

why the conditional? the plugin was specifically written to block that bug
and block it did ;).

> +config GCC_PLUGIN_STRUCTLEAK
> +	bool "Force initialization of variables containing userspace addresses"
> +	depends on GCC_PLUGINS
> +	help
> +	  This plugin zero-initializes any structures that containing a
> +	  __user attribute. This can prevent some classes of information
> +	  exposures.

i see that you completely ditched the description in PaX, is there a reason
for it? your text isn't correct as is because

- the __user attribute (which is an implementation choice, see below) doesn't
  apply to structures but pointers only (as it does for sparse IIRC)

- a structure is a type, but the plugin initializes variables, not types
  (the latter makes little sense)

- the plugin doesn't initialize 'any structures' (well, variables), only locals
  and only at function scope (subject to further evolution as discussed earlier).

> +config GCC_PLUGIN_STRUCTLEAK_VERBOSE
> +	bool "Report initialized variables"
> +	depends on GCC_PLUGIN_STRUCTLEAK
> +	depends on !COMPILE_TEST
> +	help
> +	  This option will cause a warning to be printed each time the
> +	  structleak plugin finds a variable it thinks needs to be
> +	  initialized. Since not all existing initializers are detected
> +	  by the plugin, this can produce false positive warnings.

there are no false positives, a variable either has a constructor or it does not ;)

> +/* unused C type flag in all versions 4.5-6 */
> +#define TYPE_USERSPACE(TYPE) TYPE_LANG_FLAG_5(TYPE)

FYI, this is a sort of abuse/hack of tree flags and should not be implemented this
way in the upstream kernel as it's a finite resource and needs careful verification
against all supported gcc versions (these flags are meant for language fronteds, i
kinda got lucky to have a few of them unusued but it's not a robust future-proof
approach). instead an attribute should be used to mark these types. whether that
can/should be __user itself is a good question since that's another hack where the
plugin 'hijacks' a sparse address space atttribute (for which gcc 4.6+ has its own
facilities and that the checker gcc plugin makes use of thus it's not compatible
with structleak as is).
