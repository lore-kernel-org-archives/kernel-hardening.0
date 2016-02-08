Reply-To: kernel-hardening@lists.openwall.com
References: <20160207222721.e0087a07fa604b5dac79a109@gmail.com>
 <20160207222844.dc001c6608c3f3f4cb7a8e22@gmail.com>
From: Michal Marek <mmarek@suse.com>
Message-ID: <56B8FA5D.20104@suse.com>
Date: Mon, 8 Feb 2016 21:28:13 +0100
MIME-Version: 1.0
In-Reply-To: <20160207222844.dc001c6608c3f3f4cb7a8e22@gmail.com>
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 1/3] GCC plugin infrastructure
To: Emese Revfy <re.emese@gmail.com>
Cc: linux-kbuild@vger.kernel.org, pageexec@freemail.hu, spender@grsecurity.net, kernel-hardening@lists.openwall.com, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

Dne 7.2.2016 v 22:28 Emese Revfy napsal(a):
> This patch allows to build the whole kernel with GCC plugins. It was ported from
> grsecurity/PaX. The infrastructure supports building out-of-tree modules and
> building in a separate directory. Cross-compilation is supported too but
> currently only the x86 architecture enables plugins.
> 
> The directory of the gcc plugins is tools/gcc. You can use a file or a directory
> there. The plugins compile with these options:
>  * -fno-rtti: gcc is compiled with this option so the plugins must use it too
>  * -fno-exceptions: this is inherited from gcc too
>  * -fasynchronous-unwind-tables: this is inherited from gcc too
>  * -ggdb: it is useful for debugging a plugin (better backtrace on internal
>     errors)
>  * -Wno-narrowing: to suppress warnings from gcc headers (ipa-utils.h)
>  * -Wno-unused-variable: to suppress warnings from gcc headers (gcc_version
>     variable, plugin-version.h)
> 
> The infrastructure introduces a new Makefile target called gcc-plugins. It
> supports all gcc versions from 4.5 to 6.0. The scripts/gcc-plugin.sh script
> chooses the proper host compiler (gcc-4.7 can be built by either gcc or g++).
> This script also checks the availability of the included headers in
> tools/gcc/gcc-common.h.
> 
> The gcc-common.h header contains frequently included headers for GCC plugins
> and it has a compatibility layer for the supported gcc versions.

The changelog is missing an explanation as to why this needs to be part
of the kernel build system. To me it looks like building the kernel with
a modified build system and non-default compiler flags, which can be
achieved by doing make CC=my-gcc-wrapper or somesuch. But I'd love to be
corrected.

Michal
