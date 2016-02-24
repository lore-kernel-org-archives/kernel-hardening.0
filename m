Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAGXu5jKq-A+ysyP0TZSK1qT5Scu_9ekHU_GgYaQQJm9ftNjEqw@mail.gmail.com>
References: <1455844533-24787-1-git-send-email-labbott@fedoraproject.org>
	<CAGXu5jLREPiCHSwk1LGKJm0pPGpD8O4S+4xu5=Aw_x+COLBXWg@mail.gmail.com>
	<56C79301.5040003@redhat.com>
	<CAGXu5jJ9py=VTyPDzAzD87XXUuMAOE-f+x+5eLUns_yxtkDWiA@mail.gmail.com>
	<56C7A02F.7070902@redhat.com>
	<CAGXu5jLdQNx7ineLf0zv67O30ituQ3a8WHKLBN5FzGVjMz27Bg@mail.gmail.com>
	<56CB866A.8070306@redhat.com>
	<CAGXu5jLXDmyGqXWqFp4dzmKmmfmZ+dW53200OByS2+0_63CT+Q@mail.gmail.com>
	<CAGXu5jJz-dWvHFV9jeQhT-r-bTFGxYypBniTjwnw9qp_LhLJ-w@mail.gmail.com>
	<56CE072F.7060804@redhat.com>
	<CAGXu5jKq-A+ysyP0TZSK1qT5Scu_9ekHU_GgYaQQJm9ftNjEqw@mail.gmail.com>
Date: Wed, 24 Feb 2016 15:37:53 -0800
Message-ID: <CAGXu5jLVwbaGpeHuMuZOc2H3gc=_pQ=Mao6jD71r3ZJ+6eDu_A@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCHv2] lkdtm: Add READ_AFTER_FREE test
To: Laura Abbott <labbott@redhat.com>
Cc: Laura Abbott <labbott@fedoraproject.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Feb 24, 2016 at 1:48 PM, Kees Cook <keescook@chromium.org> wrote:
> On Wed, Feb 24, 2016 at 11:40 AM, Laura Abbott <labbott@redhat.com> wrote:
>> Yep, looks like the v1 patches and not the v2 patches which fix
>> a known issue with the zeroing.
>
> Ah-ha, I'll go find those and retest.

I sent out a series that was rebased. It works for me, but I want to
make sure I didn't make any glaring issues. I've also sent some fixes
to the lkdtm tests. One thing that stands out to me still is that the
READ_AFTER_FREE never shows poisoning. I remain confused, since
obviously if zeroing is working, it's being correctly poisoned...

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
