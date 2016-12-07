Reply-To: kernel-hardening@lists.openwall.com
References: <20161206062800.21800-1-andrew.donnellan@au1.ibm.com>
 <20161206062800.21800-3-andrew.donnellan@au1.ibm.com>
From: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Date: Wed, 7 Dec 2016 16:45:54 +1100
MIME-Version: 1.0
In-Reply-To: <20161206062800.21800-3-andrew.donnellan@au1.ibm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Message-Id: <d7861b43-cda8-0212-b2fb-7331c8f6996d@au1.ibm.com>
Subject: [kernel-hardening] Re: [PATCH 3/3] powerpc: enable support for GCC plugins
To: linuxppc-dev@lists.ozlabs.org, kernel-hardening@lists.openwall.com, keescook@chromium.org, re.emese@gmail.com
Cc: pageexec@freemail.hu, spender@grsecurity.net, linux-kernel@vger.kernel.org, mmarek@suse.com, linux-kbuild@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On 06/12/16 17:28, Andrew Donnellan wrote:
> Enable support for GCC plugins on powerpc.
>
> Add an additional version check in gcc-plugins-check to advise users to
> upgrade to gcc 5.2+ on powerpc to avoid issues with header files (gcc <=
> 4.6) or missing copies of rs6000-cpus.def (4.8 to 5.1 on 64-bit targets).
>
> Signed-off-by: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
>
> ---
>
> Open to bikeshedding on the gcc version check.
>
> Compile tested with all plugins enabled on gcc 4.6-6.2,
> x86->ppc{32,64,64le} and 4.8-6.2 ppc64le->ppc{32,64,64le}. Thanks to
> Chris Smart for help with this.
>
> I think it's best to take this through powerpc#next with an ACK from
> Kees/Emese?
> ---
>  arch/powerpc/Kconfig         | 1 +
>  scripts/Makefile.gcc-plugins | 8 ++++++++

Will respin with an update to Documentation/gcc-plugins.txt as well.

-- 
Andrew Donnellan              OzLabs, ADL Canberra
andrew.donnellan@au1.ibm.com  IBM Australia Limited
