Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 6 Dec 2016 22:25:20 +0100
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20161206222520.7fb37896488eff1b299eb3db@gmail.com>
In-Reply-To: <20161206062800.21800-3-andrew.donnellan@au1.ibm.com>
References: <20161206062800.21800-1-andrew.donnellan@au1.ibm.com>
	<20161206062800.21800-3-andrew.donnellan@au1.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 3/3] powerpc: enable support for GCC plugins
To: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, kernel-hardening@lists.openwall.com, keescook@chromium.org, linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org, pageexec@freemail.hu, spender@grsecurity.net, mmarek@suse.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue,  6 Dec 2016 17:28:00 +1100
Andrew Donnellan <andrew.donnellan@au1.ibm.com> wrote:

> +      # Various gccs between 4.5 and 5.1 have bugs on powerpc due to missing
> +      # header files. gcc <= 4.6 doesn't work at all, gccs from 4.8 to 5.1 have
> +      # issues with 64-bit targets.
> +      ifeq ($(ARCH),powerpc)
> +        ifeq ($(call cc-ifversion, -le, 0501, y), y)
> +	  @echo "Cannot use CONFIG_GCC_PLUGINS: plugin support on gcc <= 5.1 is buggy on powerpc, please upgrade to gcc 5.2 or newer" >&2 && exit 1
> +        endif
> +      endif

Hi,

What are these missing headers? Because if they aren't necessary then they can
be removed from gcc-common.h. There were missing headers on arm/arm64 and these
archs are supported. I think this version check is unnecessary because
gcc-plugin.sh also checks the missing headers.

What is the problem on gcc-4.5/gcc-4.6?

-- 
Emese
