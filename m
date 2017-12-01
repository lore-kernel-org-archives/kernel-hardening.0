MIME-Version: 1.0
In-Reply-To: <20171129204812.GE6217@eros>
References: <1511850724-2381-1-git-send-email-me@tobin.cc> <CAJ1xhMXjSTV92DxRz269sB=fZLEXJimr7_8PX8viamm02+xN1w@mail.gmail.com>
 <20171128211003.GY17858@eros> <CAJ1xhMUV8G+-e8fO2MGEWvQGpLVBsETWTpyMZ5wb9evoszZEJg@mail.gmail.com>
 <20171129101640.GC6217@eros> <CAPDLWs8ooetPXhuHXyCLZ2LnPRKBf0CSMoESbXMD4sGnLLNFuA@mail.gmail.com>
 <20171129204812.GE6217@eros>
From: Kaiwan N Billimoria <kaiwan.billimoria@gmail.com>
Date: Fri, 1 Dec 2017 18:33:40 +0530
Message-ID: <CAPDLWs9wJEyLrP7ox1AxXLRPByRvPHs=A3rw0CNTs4J+VmUboQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH] leaking_addresses: add support for 32-bit kernel addresses
To: "Tobin C. Harding" <me@tobin.cc>
Cc: Alexander Kapshuk <alexander.kapshuk@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

Pl see my re inline below..
Will also follow up this mail with a patch with (minor) fixes for the
last one Tobin sent, and,
hopefully, that should mostly have the whole thing done (for now at least!)..

Thanks,
Kaiwan.

On Thu, Nov 30, 2017 at 2:18 AM, Tobin C. Harding <me@tobin.cc> wrote:
> On Wed, Nov 29, 2017 at 04:32:54PM +0530, Kaiwan N Billimoria wrote:

>> This "fallback to 0xc0000000" I don't really agree with.
>> Obviously, there are platforms out there that do not use a PAGE_OFFSET value of
>> 0xc0000000. So I think that defaulting to this is kinda presumptive;
>> much better, IMHO,
>> if we just fail and ask the user to pass the "correct" PAGE_OFFSET value via
>> the '--page-offset-32bit=' option switch.
>> What do you say?
>
> If we fallback to some sane value (it does not have to be 0xc0000000
> but that seems the most obvious) then the script has more chance of
> running by default. Why do I think it is better to run by default even
> with the wrong virtual address spilt, well since the correct value is
> basically just eliminating false positives (non-kernel addresses) it
> seems more right to run by default with extra false positives than to
> fail and place demands on the user. This will be especially useful if we
> get the script running in any continuous integration tools.
>
> We should definitely be noisy if we fallback to the default value
> though.

Yes, that's a valid argument. Will go with this..

> I just tried to save and apply it on my end and it works. How are you
> saving it? What email client are you using? Perhaps try to create a
> simple patch yourself, email to yourself, save it and apply it to a
> clean branch.
Huh.. wierd issues on my end, I guess.. will sort it out, thanks.
