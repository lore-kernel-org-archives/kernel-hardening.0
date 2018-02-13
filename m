MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20180213145632.GA7937@infradead.org>
References: <123377.1517765678@turing-police.cc.vt.edu> <20180213145632.GA7937@infradead.org>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 13 Feb 2018 07:26:09 -0800
Message-ID: <CAGXu5jLtb46yFK1TRE3WBPp6grQQGbCbqGCTYJJ7dok3Kws8pg@mail.gmail.com>
Subject: Re: [PATCH 2/2] GCC release 8 support for gcc-plugins
Content-Type: text/plain; charset="UTF-8"
To: Christoph Hellwig <hch@infradead.org>
Cc: Valdis Kletnieks <valdis.kletnieks@vt.edu>, Kernel Hardening <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 13, 2018 at 6:56 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Sun, Feb 04, 2018 at 12:34:38PM -0500, valdis.kletnieks@vt.edu wrote:
>> For reasons totally beyond my understanding, gcc 8 changed the
>> order of two structure member, which leads to an error:
>
> I'm a little late on this, but isn't the whole point of C99 initializers
> that field order should not matter at all?

For C99, this is true. The plugins are built differently and follow
C++ conventions, which, for reasons I cannot understand, are ordered.
:( Regardless, the fix actually results in fewer lines of code, so
this is fine.

-Kees

-- 
Kees Cook
Pixel Security
