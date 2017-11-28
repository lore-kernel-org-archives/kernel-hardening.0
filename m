MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20171128221237.GR729@wotan.suse.de>
References: <1511803118-2552-1-git-send-email-tixxdz@gmail.com>
 <1511803118-2552-2-git-send-email-tixxdz@gmail.com> <20171128191405.GO729@wotan.suse.de>
 <CAGXu5jKgHWNE4NH_xqcM084-BNBPy+HmEVPbTA+w_=K3S6gC=w@mail.gmail.com>
 <20171128211659.GP729@wotan.suse.de> <CAGXu5j+JaFCo+pZKvet==Kh7GQgNXi30P50SMF4cpOGoUw-8ug@mail.gmail.com>
 <20171128221237.GR729@wotan.suse.de>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 28 Nov 2017 14:18:18 -0800
Message-ID: <CAGXu5jKqMeBUB4iArqw9_iyKqm3NjpCrU_byy90kZrAHDb0c9w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v5 next 1/5] modules:capabilities: add request_module_cap()
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Djalal Harouni <tixxdz@gmail.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, James Morris <james.l.morris@oracle.com>, Ben Hutchings <ben.hutchings@codethink.co.uk>, Solar Designer <solar@openwall.com>, Serge Hallyn <serge@hallyn.com>, Jessica Yu <jeyu@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>, LKML <linux-kernel@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, kernel-hardening@lists.openwall.com, Jonathan Corbet <corbet@lwn.net>, Ingo Molnar <mingo@kernel.org>, "David S. Miller" <davem@davemloft.net>, Network Development <netdev@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Nov 28, 2017 at 2:12 PM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> On Tue, Nov 28, 2017 at 01:39:58PM -0800, Kees Cook wrote:
>> On Tue, Nov 28, 2017 at 1:16 PM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
>> > And *all* auto-loading uses aliases? What's the difference between auto-loading
>> > and direct-loading?
>>
>> The difference is the process privileges. Unprivilged autoloading
>> (e.g. int n_hdlc = N_HDLC; ioctl(fd,
>> TIOCSETD, &n_hdlc)), triggers a privileged call to finit_module()
>> under CAP_SYS_MODULE.
>
> Ah, so system call implicated request_module() calls.

Yup. Unprivileged user does something that ultimately hits a
request_module() in the kernel. Then the kernel calls out with the
usermode helper (which has CAP_SYS_MODULE) and calls finit_module().

> OK and since CAP_SYS_MODULE is much more restrictive one could argue, what's the
> point here?

The goal is to block an unprivileged user from being able to trigger a
module load without blocking root from loading modules directly.

-Kees

-- 
Kees Cook
Pixel Security
