Reply-To: kernel-hardening@lists.openwall.com
Sender: James Hogan <james@albanarts.com>
In-Reply-To: <20160927101236.GB26796@pathway.suse.cz>
References: <20160916203819.GA29767@roeck-us.net> <20160916212720.GA18931@jhogan-linux.le.imgtec.org> <20160916213718.GA32384@roeck-us.net> <20160916233249.GB18931@jhogan-linux.le.imgtec.org> <20160919145529.GK18931@jhogan-linux.le.imgtec.org> <20160919154509.GA24003@roeck-us.net> <20160927101236.GB26796@pathway.suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
From: James Hogan <james.hogan@imgtec.com>
Date: Tue, 27 Sep 2016 11:19:29 +0100
Message-ID: <6D0F388E-944D-4104-8849-F662A191473D@imgtec.com>
Subject: [kernel-hardening] Re: qemu:metag image runtime failure in -next due to 'kthread: allow to cancel kthread work'
To: Petr Mladek <pmladek@suse.com>, Guenter Roeck <linux@roeck-us.net>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, linux-metag@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 27 September 2016 11:12:36 BST, Petr Mladek <pmladek@suse.com> wrote:
>On Mon 2016-09-19 08:45:09, Guenter Roeck wrote:
>> On Mon, Sep 19, 2016 at 03:55:29PM +0100, James Hogan wrote:
>> > On Sat, Sep 17, 2016 at 12:32:49AM +0100, James Hogan wrote:
>> > > Here this version of QEMU puts the args at where it thinks the
>end of
>> > > the loaded image is, which is based on the number of bytes copied
>from
>> > > the ELF, i.e. the total MemSiz's, not taking into account the
>alignment
>> > > gap in between, so it puts them at 0x40377348.
>> > 
>> > QEMU meta-v1.3.1 branch updated at:
>> > https://github.com/img-meta/qemu.git
>> > 
>> > Hopefully that'll fix it for you Guenter.
>> > 
>> Confirmed fixed.
>
>Could you please confirm that the boot problem has been fixed
>on the qemu side? I guess that it is
>https://github.com/img-meta/qemu/commit/0a2402860228198ae2729048f1de05aeedb7d642

Yes, that patch is sufficient.

>
>Could Andrew enable all the kthread worker API improvements in -mm
>tree again?
>
>I think that kthread worker patch has been an innocent victim.
>It added some functions that were not used anywhere. I think
>that it has triggered the boot problem just by chance.

Agreed, it altered the alignment of the sections enough to trigger linker generating multiple load program headers with a gap in between which confused qemu.

Cheers
James
