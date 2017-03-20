From: Michael Ellerman <mpe@ellerman.id.au>
In-Reply-To: <20170320065522.14839-1-andrew.donnellan@au1.ibm.com>
References: <20170320065522.14839-1-andrew.donnellan@au1.ibm.com>
Date: Mon, 20 Mar 2017 19:39:48 +1100
Message-ID: <87var44a0b.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Subject: [kernel-hardening] Re: [PATCH] gcc-plugins: update architecture list in documentation
To: Andrew Donnellan <andrew.donnellan@au1.ibm.com>, keescook@chromium.org, re.emese@gmail.com, kernel-hardening@lists.openwall.com, corbet@lwn.net, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
List-ID: <kernel-hardening.lists.openwall.com>

Andrew Donnellan <andrew.donnellan@au1.ibm.com> writes:

> Commit 65c059bcaa73 ("powerpc: Enable support for GCC plugins") enabled GCC
> plugins on powerpc, but neglected to update the architecture list in the
> docs. Rectify this.
>
> Fixes: 65c059bcaa73 ("powerpc: Enable support for GCC plugins")
> Signed-off-by: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
> ---
>  Documentation/gcc-plugins.txt | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

It would be nice to merge this for v4.11, so the docs are up to do date
with the code for the release.

I'm not sure who owns it though, should it go via Jon as docs
maintainer (added to CC), or via Kees tree or mine?

cheers


>
> diff --git a/Documentation/gcc-plugins.txt b/Documentation/gcc-plugins.txt
> index 891c69464434..433eaefb4aa1 100644
> --- a/Documentation/gcc-plugins.txt
> +++ b/Documentation/gcc-plugins.txt
> @@ -18,8 +18,8 @@ because gcc versions 4.5 and 4.6 are compiled by a C compiler,
>  gcc-4.7 can be compiled by a C or a C++ compiler,
>  and versions 4.8+ can only be compiled by a C++ compiler.
>  
> -Currently the GCC plugin infrastructure supports only the x86, arm and arm64
> -architectures.
> +Currently the GCC plugin infrastructure supports only the x86, arm, arm64 and
> +powerpc architectures.
>  
>  This infrastructure was ported from grsecurity [6] and PaX [7].
>  
> -- 
> Andrew Donnellan              OzLabs, ADL Canberra
> andrew.donnellan@au1.ibm.com  IBM Australia Limited
