MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20180404214007.31a5fbc6@bbrezillon>
References: <20180328205138.301218351@linutronix.de> <20180328205554.666762229@linutronix.de>
 <20180404214007.31a5fbc6@bbrezillon>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 18 Apr 2018 10:03:44 -0700
Message-ID: <CAGXu5j+rckvb94YhdqUhRhuG=RtjN+S9QArAhwVWPj8mbPom+w@mail.gmail.com>
Subject: Re: [patch 5/8] rslib: Split rs control struct
Content-Type: text/plain; charset="UTF-8"
To: Boris Brezillon <boris.brezillon@bootlin.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>, Segher Boessenkool <segher@kernel.crashing.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Andrew Morton <akpm@linuxfoundation.org>, Boris Brezillon <boris.brezillon@free-electrons.com>, Richard Weinberger <richard@nod.at>, David Woodhouse <dwmw2@infradead.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Apr 4, 2018 at 12:40 PM, Boris Brezillon
<boris.brezillon@bootlin.com> wrote:
> Hi Thomas,
>
> On Wed, 28 Mar 2018 22:51:43 +0200
> Thomas Gleixner <tglx@linutronix.de> wrote:
>
>> The decoder library uses variable length arrays on stack. To get rid of
>> them it's it would be simple to allocate fixed length arrays on stack, but
>
>        ^ s/it's//
>
>> those might become rather large. The other solution is to allocate the
>> buffers in the rs control structure, but this cannot be done as long as the
>> structure can be shared by several users. Sharing is desired because the RS
>> polynom tables are large and initialization is time consuming.
>>
>> To solve this split the codec information out of the control structure and
>> have a pointer to a shared codec in it. Instantiate the control structure
>> for each user, create a new codec if no shareable is avaiable yet.  Adjust
>> all affected usage sites to the new scheme.
>>
>> This allows to add per instance decoder buffers to the control structure
>> later on.
>>
>> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>> ---
>>  drivers/mtd/nand/cafe_nand.c    |    7 +
>>  drivers/mtd/nand/diskonchip.c   |    7 +
>
> Don't know how you want to get these patches merged, but the NAND
> related changes will conflict with my nand/for-4.17 changes (NAND
> code base has been moved to drivers/mtd/nand/raw).
>
> The rest looks good,
>
> Acked-by: Boris Brezillon <boris.brezillon@bootlin.com>

Hi, just checking in on this series. Thomas, what's your plan for
merging this? I don't see it in -next yet.

-Kees

-- 
Kees Cook
Pixel Security
