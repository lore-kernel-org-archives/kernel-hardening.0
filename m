Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1475476886-26232-1-git-send-email-elena.reshetova@intel.com>
References: <1475476886-26232-1-git-send-email-elena.reshetova@intel.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 3 Oct 2016 14:01:09 -0700
Message-ID: <CAGXu5jLSuf+NpuSnP_VmykCMKS_BHfygx5JimhrK7nJmTQf7ig@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC PATCH 00/13] HARDENING_ATOMIC feature
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Oct 2, 2016 at 11:41 PM, Elena Reshetova
<elena.reshetova@intel.com> wrote:
> This series brings the PaX/Grsecurity PAX_REFCOUNT [1]
> feature support to the upstream kernel. All credit for the
> feature goes to the feature authors.
>
> The name of the upstream feature is HARDENED_ATOMIC
> and it is configured using CONFIG_HARDENED_ATOMIC and
> HAVE_ARCH_HARDENED_ATOMIC.
>
> This series only adds x86 support; other architectures are expected
> to add similar support gradually.
>
> More information about the feature can be found in the following
> commit messages.
>
> Special thank you goes to Kees Cook for pre-reviwing this feature
> and all the valuable feedback he provided to us.
>
> David Windsor (7):
>   kernel: identify wrapping atomic usage
>   mm: identify wrapping atomic usage
>   fs: identify wrapping atomic usage
>   net: identify wrapping atomic usage
>   security: identify wrapping atomic usage
>   drivers: identify wrapping atomic usage (part 1/2)
>   drivers: identify wrapping atomic usage (part 2/2)
>
> Elena Reshetova (2):
>   Add architecture independent hardened atomic base
>   x86: x86 implementation for HARDENED_ATOMIC
>
> Hans Liljestrand (4):
>   percpu-refcount: leave atomic counter unprotected
>   net: atm: identify wrapping atomic usage
>   x86: identify wrapping atomic usage
>   lkdtm: add tests for atomic over-/underflow

This is great; thanks for collaborating on this!

I'm curious to see if Greg KH has suggestions on ways to improve the
"identify wrapping atomic usage" series, which touches the tree very
widely.

I'll go through the series with some nits and comments. I'm excited to
see this making progress, since it's proven itself to be quite
valuable in PaX/Grsecurity.

-Kees

-- 
Kees Cook
Nexus Security
