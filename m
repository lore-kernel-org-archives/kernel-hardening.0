Reply-To: kernel-hardening@lists.openwall.com
References: <20161206062800.21800-1-andrew.donnellan@au1.ibm.com>
 <20161206062800.21800-3-andrew.donnellan@au1.ibm.com>
 <CAGXu5jKQf4ReBkGC85+r_j1rVUFTZoeWk9A_mjhjnFHq1PAr8Q@mail.gmail.com>
From: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Date: Wed, 7 Dec 2016 12:05:26 +1100
MIME-Version: 1.0
In-Reply-To: <CAGXu5jKQf4ReBkGC85+r_j1rVUFTZoeWk9A_mjhjnFHq1PAr8Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Message-Id: <bf236e17-4b0f-e0c4-ba4d-4aadc1662b82@au1.ibm.com>
Subject: Re: [kernel-hardening] Re: [PATCH 3/3] powerpc: enable support for
 GCC plugins
To: kernel-hardening@lists.openwall.com
Cc: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, Emese Revfy <re.emese@gmail.com>, LKML <linux-kernel@vger.kernel.org>, linux-kbuild <linux-kbuild@vger.kernel.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Michal Marek <mmarek@suse.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 07/12/16 07:40, Kees Cook wrote:
>> Compile tested with all plugins enabled on gcc 4.6-6.2,
>> x86->ppc{32,64,64le} and 4.8-6.2 ppc64le->ppc{32,64,64le}. Thanks to
>> Chris Smart for help with this.
>
> I assume also tested on 5.2? :)

Tested on the latest subrevision of every release branch up till 6.2, so 
yes :)

>> I think it's best to take this through powerpc#next with an ACK from
>> Kees/Emese?
>
> That would be fine by me. Please consider the whole series:
>
> Acked-by: Kees Cook <keescook@chromium.org>

Thanks!

-- 
Andrew Donnellan              OzLabs, ADL Canberra
andrew.donnellan@au1.ibm.com  IBM Australia Limited
