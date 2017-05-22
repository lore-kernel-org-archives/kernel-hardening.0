References: <20170522013233.21780-1-dja@axtens.net>
 <20170522013607.89E5CAE034@b01ledav005.gho.pok.ibm.com>
From: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Date: Mon, 22 May 2017 14:29:39 +1000
MIME-Version: 1.0
In-Reply-To: <20170522013607.89E5CAE034@b01ledav005.gho.pok.ibm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Message-Id: <df86cc49-03e6-be24-0b5e-fd0d0d618f48@au1.ibm.com>
Subject: [kernel-hardening] Re: [PATCH 1/2] powerpc: Don't fortify prom_init
To: Daniel Axtens <dja@axtens.net>, kernel-hardening@lists.openwall.com, linuxppc-dev@lists.ozlabs.org
Cc: Daniel Micay <danielmicay@gmail.com>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 22/05/17 11:32, Daniel Axtens wrote:
> prom_init is a bit special; in theory it should be able to be
> linked separately to the kernel. To keep this from getting too
> complex, the symbols that prom_init.c uses are checked.
>
> Fortification adds symbols, and it gets quite messy as it includes
> things like panic(). So just don't fortify prom_init.c for now.
>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Daniel Micay <danielmicay@gmail.com>
> Signed-off-by: Daniel Axtens <dja@axtens.net>

Reviewed-by: Andrew Donnellan <andrew.donnellan@au1.ibm.com>

-- 
Andrew Donnellan              OzLabs, ADL Canberra
andrew.donnellan@au1.ibm.com  IBM Australia Limited
