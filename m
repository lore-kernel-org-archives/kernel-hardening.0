Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20151107223437.891207864301c26862ae15da@gmail.com>
References: <20151106235545.97d0e86a5f1f80c98e0e9de6@gmail.com>
	<CAGXu5jK2boq=rSwrdyqyq=B_kZJR2pUQe99+tPBwK+pKEx0X+w@mail.gmail.com>
	<20151107223437.891207864301c26862ae15da@gmail.com>
Date: Sat, 7 Nov 2015 22:40:39 -0800
Message-ID: <CAGXu5j+9g3Dk__C79xGAMBHYcg7mFXB05DVx7Us4MzC794NYTg@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: Proposal for kernel self protection features
To: Emese Revfy <re.emese@gmail.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Greg KH <gregkh@linuxfoundation.org>, Theodore Tso <tytso@google.com>, Josh Triplett <josh@joshtriplett.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Nov 7, 2015 at 1:34 PM, Emese Revfy <re.emese@gmail.com> wrote:
>> speak to any known bugs it stopped? Having some mention of the threat
>> it mitigates would be helpful. (Do I remember correctly that it
>> constified security_operations, which was a common target in
>> exploits?)
>
> I don't remember any bugs, but I think spender has some exploits that
> are stopped by constification :) The constify plugin stops exploits that
> want to modify ops structures to control indirect calls through them.

Yeah, just listing a few somewhere in the future patch or docs would
be cool, or we can add that to the wiki, etc. Mostly I just want to be
able to help people understand what a given mitigation could have
stopped, etc. (And given the frequency of ops structure abuse in just
the exploits I reviewed for the Kernel Summit slides, that's a lot...)
Since many people don't understand the value of exploit-blocking, it's
nice to point specifically to known exploits that would have been
blocked.

-Kees

-- 
Kees Cook
Chrome OS Security
