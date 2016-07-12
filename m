Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <86866.1468347964@turing-police.cc.vt.edu>
References: <1467843928-29351-1-git-send-email-keescook@chromium.org> <86866.1468347964@turing-police.cc.vt.edu>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 12 Jul 2016 14:44:35 -0400
Message-ID: <CAGXu5jL2L8LeX2DRij1nax+s-xfz7+qDO_=_fCri318kB1zPsg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH 0/9] mm: Hardened usercopy
To: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jul 12, 2016 at 2:26 PM,  <Valdis.Kletnieks@vt.edu> wrote:
> On Wed, 06 Jul 2016 15:25:19 -0700, Kees Cook said:
>> Hi,
>>
>> This is a start of the mainline port of PAX_USERCOPY[1]. After I started
>> writing tests (now in lkdtm in -next) for Casey's earlier port[2], I
>> kept tweaking things further and further until I ended up with a whole
>> new patch series. To that end, I took Rik's feedback and made a number
>> of other changes and clean-ups as well.
>
> And the good news is that my issues with ptrace() and ping seem to
> have cleared up - I suspect there was a dangling piece of the original
> 4-patch series still lurking in my tree that appears to have been
> slayed by a 'git reset --hard'.
>
> Am running a next-20160708 kernel with the 9-patch series and it's working...

Great! Thanks for checking. :)

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
