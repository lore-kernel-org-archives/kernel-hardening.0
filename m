Reply-To: kernel-hardening@lists.openwall.com
References: <20160513015456.01415979f20a68eb7d2d9290@gmail.com>
 <20160513015725.30223ee16a2a3860b4392b90@gmail.com>
 <573C2CFE.8060305@au1.ibm.com>
 <20160518123327.9018f73af78a47b4456b2027@gmail.com>
 <1463638931.10451.10.camel@ellerman.id.au>
From: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Message-ID: <573D5D7F.60000@au1.ibm.com>
Date: Thu, 19 May 2016 16:30:23 +1000
MIME-Version: 1.0
In-Reply-To: <1463638931.10451.10.camel@ellerman.id.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [PATCH v8 2/4] GCC plugin infrastructure
To: Michael Ellerman <mpe@ellerman.id.au>, Emese Revfy <re.emese@gmail.com>, kernel-hardening@lists.openwall.com
Cc: linux-kbuild@vger.kernel.org, pageexec@freemail.hu, spender@grsecurity.net, mmarek@suse.com, keescook@chromium.org, linux@rasmusvillemoes.dk, fengguang.wu@intel.com, dvyukov@google.com, linux-kernel@vger.kernel.org, david.brown@linaro.org, yamada.masahiro@socionext.com, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, Daniel Axtens <dja@axtens.net>
List-ID: <kernel-hardening.lists.openwall.com>

On 19/05/16 16:22, Michael Ellerman wrote:
>> Did you test the plugins with all gcc versions (4.5-6)?
>
> What's the concern about gcc versions? Just not breaking the build on old
> compilers?
> I'm pretty sure powerpc big endian still builds with gcc 4.4.

gcc's plugin support only landed in 4.5, so we don't care about <=4.4.

> However if Andrew's only tested on little endian, then that select should be
> guarded with an "if CPU_LITTLE_ENDIAN". And to build LE you need gcc >= 4.9.

I'm going to give BE a test too just to be sure.

-- 
Andrew Donnellan              OzLabs, ADL Canberra
andrew.donnellan@au1.ibm.com  IBM Australia Limited
