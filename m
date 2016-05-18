Reply-To: kernel-hardening@lists.openwall.com
References: <20160513015456.01415979f20a68eb7d2d9290@gmail.com>
 <20160513015725.30223ee16a2a3860b4392b90@gmail.com>
 <573C2CFE.8060305@au1.ibm.com>
 <20160518123327.9018f73af78a47b4456b2027@gmail.com>
From: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Message-ID: <573CDB52.30701@au1.ibm.com>
Date: Thu, 19 May 2016 07:14:58 +1000
MIME-Version: 1.0
In-Reply-To: <20160518123327.9018f73af78a47b4456b2027@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [PATCH v8 2/4] GCC plugin infrastructure
To: Emese Revfy <re.emese@gmail.com>, kernel-hardening@lists.openwall.com
Cc: linux-kbuild@vger.kernel.org, pageexec@freemail.hu, spender@grsecurity.net, mmarek@suse.com, keescook@chromium.org, linux@rasmusvillemoes.dk, fengguang.wu@intel.com, dvyukov@google.com, linux-kernel@vger.kernel.org, david.brown@linaro.org, yamada.masahiro@socionext.com, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, Michael Ellerman <mpe@ellerman.id.au>, Daniel Axtens <dja@axtens.net>
List-ID: <kernel-hardening.lists.openwall.com>

On 18/05/16 20:33, Emese Revfy wrote:
> Did you test the plugins with all gcc versions (4.5-6)?

No, I tested with 4.8 and 5.2 as those are the toolchains I have on hand 
- I'll try to test with the rest of 4.5 - 6.1.

-- 
Andrew Donnellan              OzLabs, ADL Canberra
andrew.donnellan@au1.ibm.com  IBM Australia Limited
