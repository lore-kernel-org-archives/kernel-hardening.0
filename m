Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20120217154213.ecf4f7b4.akpm@linux-foundation.org>
References: <20120107185548.GA30748@outflux.net>
	<20120217152432.112fdace.akpm@linux-foundation.org>
	<CAGXu5jJ629rrEuQX1MSiqM2SvhCSmZYuNZdOA4zBr5GZHtFcuw@mail.gmail.com>
	<20120217154213.ecf4f7b4.akpm@linux-foundation.org>
Date: Fri, 17 Feb 2012 17:09:52 -0800
Message-ID: <CAGXu5j+ZawBrPbSXSYH9hU5LQqtgebOhkAkDMsxiraoNZkE7og@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: [PATCH v2012.2] fs: symlink restrictions on sticky directories
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Rik van Riel <riel@redhat.com>, Federica Teodori <federica.teodori@googlemail.com>, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>, Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Eric Paris <eparis@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>, Dan Rosenberg <drosenberg@vsecurity.com>, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Feb 17, 2012 at 3:42 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Fri, 17 Feb 2012 15:36:09 -0800
> Kees Cook <keescook@chromium.org> wrote:
>
>> > I think I disagree with this. __If the person compiling the kernel
>> > includes the feature in his kernel via the time-honoured process of
>> > "wtf is that thing? __Yeah, whatev", it gets turned on by default. __This
>> > could easily result in weird failures which would take a *long* time
>> > for an unsuspecting person to debug.
>> >
>> > Would it not be kinder to our users to start this out as
>> > turned-off-at-runtime unless the kernel configurer has deliberately
>> > gone in and enabled it?
>>
>> There was a fair bit of back-and-forth discussion about it.
>> Originally, I had it disabled, but, IIRC, Ingo urged me to have it be
>> the default. I can sent a patch to disable it if you want.
>
> What is the reasoning behind the current setting?

The logic is currently:

- from a security perspective, enabling the restriction is safer
- in the last many years, nothing has been found to be broken by this
restriction

The evidence for the second part mostly comes from people's
recollections using OpenWall, grsecurity, and lately Ubuntu. I can
speak from the Ubuntu history, which is that in the 1.5 years the
symlink restriction has been enabled, no bugs about it were reported
that I'm aware of (and I was aware of, and fixed, several of bugs in
the other restrictions that are carried in Ubuntu).

All that said, I'm fine with it being disabled by default since it can
be enabled at build or runtime with the current patch. Just say the
word. :)

Thanks,

-Kees

-- 
Kees Cook
ChromeOS Security
