Subject: Re: [PATCH 1/4] gpio: Remove VLA from gpiolib
References: <20180310001021.6437-1-labbott@redhat.com>
 <20180310001021.6437-2-labbott@redhat.com>
 <a758ce3f-fed7-2ecf-94c5-ba133ea75bde@rasmusvillemoes.dk>
 <301ecaf7-62a4-14af-3a5b-7bd76a49c4f6@redhat.com>
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Message-ID: <a55d544e-0b0c-1a5a-b474-d31eb338e8ee@rasmusvillemoes.dk>
Date: Tue, 13 Mar 2018 08:23:22 +0100
MIME-Version: 1.0
In-Reply-To: <301ecaf7-62a4-14af-3a5b-7bd76a49c4f6@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Laura Abbott <labbott@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Linus Walleij <linus.walleij@linaro.org>, Kees Cook <keescook@chromium.org>
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Lukas Wunner <lukas@wunner.de>, Mathias Duckeck <m.duckeck@kunbus.de>, Nandor Han <nandor.han@ge.com>, Semi Malinen <semi.malinen@ge.com>, Patrice Chotard <patrice.chotard@st.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 2018-03-13 00:40, Laura Abbott wrote:
> On 03/12/2018 08:00 AM, Rasmus Villemoes wrote:
>>
>> Hm, it seems you're now only clearing the first word of mask, not the
>> entire allocation. Why not just use kcalloc() instead of kmalloc_array
>> to have it automatically cleared?
> 
> Bleh, I didn't think through that carefully. I'll just switch
> to kcalloc, especially since it calls kmalloc_array.
> 
>> Other random thoughts: maybe two allocations for each loop iteration is
>> a bit much. Maybe do a first pass over the array and collect the maximal
>> chip->ngpio, do the memory allocation and freeing outside the loop (then
>> you'd of course need to preserve the memset() with appropriate length
>> computed). And maybe even just do one allocation, making bits point at
>> the second half.
>>
> 
> I was trying to make minimal changes and match the existing code.

Well, textually you may be making the minimal changes (though the error
handling adds some "boilerplate" kfree()s etc.), but semantically adding
two kmallocs in a loop could be a big deal. Dunno, maybe in practice all
the gpios (almost always) belong to the same chip, so there's only one
iteration through the loop anyway.

> Is this likely to be an actual hot path to optimize?

No idea, it was just a drive-by comment, so also...

>> Does the set function need to be updated to return an int to be able to
>> inform the caller that memory allocation failed?
> 
> That would involve changing the public API. I don't have a problem
> doing so if that's what you want.

... I don't "want" anything, that'll be for the gpio maintainers to decide.

Rasmus
