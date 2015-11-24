Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20151124212024.GB15374@kroah.com>
References: <CAEXv5_jnutg89zQLyLCupKf0AOZ=ubdgbJy7AgeeN=7yQicW0A@mail.gmail.com>
	<20151124212024.GB15374@kroah.com>
Date: Tue, 24 Nov 2015 13:47:42 -0800
Message-ID: <CAGXu5jLydRpkVOGdpLbqOq4VzAUMpWvDt_k1-q5CU9fJXPYcAg@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] status: PAX_REFCOUNT
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Cc: PaX Team <pageexec@freemail.hu>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Nov 24, 2015 at 1:20 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Tue, Nov 24, 2015 at 02:37:41PM -0500, David Windsor wrote:
>> I'm currently in the process of splitting PAX_REFCOUNT.
>>
>> It looks to touch a massive number of files.  Many of the modifications occur
>> in drivers:
>>
>> dave@strontium:~/src/linux-grsec-4.2$ grep -ril "atomic.*unchecked" | wc -l
>> 402
>> dave@strontium:~/src/linux-grsec-4.2$ grep -ril "atomic.*unchecked" drivers/ |
>> wc -l
>> 158
>
> Odds are, we can take lots of these existing atomic usages and either
> replace them with a kref, or remove them, as I can't imagine that we
> need that many different atomic variables for things that are not just
> debugging things.

Yeah, I'll be curious to get a look at it in raw extracted form. I
still want to make sure we're whitelisting, though, and not asking
people to learn a new API (unless they do NOT want the protection).

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
