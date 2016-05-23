Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 23 May 2016 19:29:46 +1000 (AEST)
From: James Morris <jmorris@namei.org>
In-Reply-To: <20160517022728.GA2821@www.outflux.net>
Message-ID: <alpine.LRH.2.20.1605231904400.10905@namei.org>
References: <20160517022728.GA2821@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH] doc: self-protection: provide initial details
To: Kees Cook <keescook@chromium.org>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 16 May 2016, Kees Cook wrote:

> +#### Segregation of kernel memory from userspace memory
> +
> +The kernel must never execute userspace memory. The kernel must also never
> +access userspace memory without explicit expectation to do so. These
> +rules can be enforced either by support of hardware-based restrictions
> +(x86's SMEP/SMAP, ARM's PXN/PAN) or via emulation (ARM's Memory Domains).
> +By blocking userspace memory in this way, execution and data parsing
> +cannot be passed to trivially-controlled userspace memory, forcing
> +attacks to operate entirely in kernel memory.

One caveat is that there may be ways to bypass these protections, e.g. via 
aliased (direct mapped) memory.

I'd also note that some platforms have separate kernel and memory spaces, 
like Sparc.


> +To protect against even privileged users, systems may need to either
> +disable module loading entirely (e.g. monolithic kernel builds or
> +modules_disabled sysctl), or provide signed modules (e.g.
> +CONFIG_MODULE_SIG_FORCE, or dm-crypt with LoadPin), to keep from having
> +oot load arbitrary kernel code via the module loader interface.

Or utilize an appropriate MAC policy.



-- 
James Morris
<jmorris@namei.org>
