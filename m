Reply-To: kernel-hardening@lists.openwall.com
References: <20160513015456.01415979f20a68eb7d2d9290@gmail.com>
 <20160518123327.9018f73af78a47b4456b2027@gmail.com>
 <1463638931.10451.10.camel@ellerman.id.au>
 <573D782D.10392.75A275C@pageexec.freemail.hu>
From: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Message-ID: <573EAD0B.7090005@au1.ibm.com>
Date: Fri, 20 May 2016 16:22:03 +1000
MIME-Version: 1.0
In-Reply-To: <573D782D.10392.75A275C@pageexec.freemail.hu>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [PATCH v8 2/4] GCC plugin infrastructure
To: pageexec@freemail.hu, Emese Revfy <re.emese@gmail.com>, kernel-hardening@lists.openwall.com, Michael Ellerman <mpe@ellerman.id.au>
Cc: linux-kbuild@vger.kernel.org, spender@grsecurity.net, mmarek@suse.com, keescook@chromium.org, linux@rasmusvillemoes.dk, fengguang.wu@intel.com, dvyukov@google.com, linux-kernel@vger.kernel.org, david.brown@linaro.org, yamada.masahiro@socionext.com, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, Daniel Axtens <dja@axtens.net>
List-ID: <kernel-hardening.lists.openwall.com>

On 19/05/16 18:24, PaX Team wrote:
> the earlier plugin capable gcc versions used to install gcc headers in a somewhat
> ad-hoc manner resulting in compile time breakage for plugins and since some of
> those potentially missing headers are target specific, each target arch should
> be verified before enabling plugin support on them. things have much improved with
> gcc 5 (see https://gcc.gnu.org/bugzilla/show_bug.cgi?id=61176) though there's still
> an occasional missing header but with wider use of plugins they will hopefully be
> discovered earlier now. perhaps linux-arch should be cc'ed on the plugin infrastructure
> so that arch maintainers are aware of this?

Upon further testing it does seem we've got header issues as well as 
hitting a segfault on 4.7.0. Looking into it further...

-- 
Andrew Donnellan              OzLabs, ADL Canberra
andrew.donnellan@au1.ibm.com  IBM Australia Limited
