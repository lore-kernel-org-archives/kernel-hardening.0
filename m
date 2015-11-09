Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <alpine.DEB.2.10.1511091747430.3745@hadrien>
References: <1447018493-20631-1-git-send-email-Julia.Lawall@lip6.fr>
	<20151108221624.GP18797@mwanda>
	<alpine.DEB.2.10.1511082220500.2583@hadrien>
	<20151109054253.GQ18797@mwanda>
	<20151109134942.GB8264@mwanda>
	<alpine.DEB.2.10.1511091449560.3103@hadrien>
	<20151109180555.28c45c3ccaf2042dd7fefec4@gmail.com>
	<alpine.DEB.2.10.1511091747430.3745@hadrien>
Date: Mon, 9 Nov 2015 13:24:27 -0800
Message-ID: <CAGXu5jJ7HvAKEs0YynnLQH9xJPgb7LKEvuaQtDY=3K9J4xawjQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: [PATCH] video: constify geode ops structures
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Emese Revfy <re.emese@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Dan Carpenter <dan.carpenter@oracle.com>, Joe Perches <joe@perches.com>, kernel-janitors@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Nov 9, 2015 at 9:48 AM, Julia Lawall <julia.lawall@lip6.fr> wrote:
> On Mon, 9 Nov 2015, Emese Revfy wrote:
>
>> On Mon, 9 Nov 2015 14:50:47 +0000 (GMT)
>> Julia Lawall <julia.lawall@lip6.fr> wrote:
>> > > Actually, it looks like Emese Revfy is going to merge the GCC plugin
>> > > constify stuff sooner rather than later so maybe adding all these consts
>> > > isn't going to be needed.
>> >
>> > Is there any advantage of const over the plugin?  The consts are easy to
>> > add.
>>
>> Hi,
>>
>> I think it's a very good advantage that the plugin constifies automatically
>> without regular maintenance (e.g., generate patches with coccinelle,
>> send patches to the maintainers every new kernel version). ;)
>> But if it doesn't convince you, I did constification by hand (with a coccinelle
>> script) some years ago.
>> There are too many types that can be const and it took too long to prepare and
>> get the maintainers to accept the patches.
>> And it never ends as there are always new types that can be const.
>
> What happens if some structures cannot be made const because there is a
> reassignment somewhere?  Is there any feedback about the problem?

AIUI, for now, we can't make those const (though I would be happy to
be corrected). My hope would be to allow reassignment using something
like PaX's kernel_open/kernel_close inlines to allow for temporary
modification of read-only things (as part of the KERNEXEC feature).

-Kees

>
> julia
>
>>
>> > Does the plugin help for structures that have non-function fields?
>> Yes, it does. See __do_const here:
>> http://www.openwall.com/lists/kernel-hardening/2015/11/06/11
>> or more about the constify plugin:
>> https://pax.grsecurity.net/docs/PaXTeam-H2HC13-PaX-gcc-plugins.pdf
>>
>> --
>> Emese
>>



-- 
Kees Cook
Chrome OS Security
