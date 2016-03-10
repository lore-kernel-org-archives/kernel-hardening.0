Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CAGXu5j+QSn1bWB41xN8OM+dg+oGeJM9bKb92x9WdsX7tk1kANw@mail.gmail.com>
References: <1457470075-4586-1-git-send-email-sbauer@eng.utah.edu>
 <1457470075-4586-3-git-send-email-sbauer@eng.utah.edu> <20160308210013.15ee166d@lxorguk.ukuu.org.uk>
 <CAGXu5j+QSn1bWB41xN8OM+dg+oGeJM9bKb92x9WdsX7tk1kANw@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 9 Mar 2016 22:46:46 -0800
Message-ID: <CALCETrVq7eUppdWxrY_DaqtLivFT1QDCwA9P=5pvSh+PhM3DWg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: [PATCH v3 3/3] SROP mitigation: Add sysctl
 to disable SROP protection.
To: Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Scott Bauer <sbauer@eng.utah.edu>, LKML <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, wmealing@redhat.com, Andi Kleen <ak@linux.intel.com>, Abhiram Balasubramanian <abhiram@cs.utah.edu>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Mar 9, 2016 at 10:36 PM, Kees Cook <keescook@chromium.org> wrote:
> On Tue, Mar 8, 2016 at 1:00 PM, One Thousand Gnomes
> <gnomes@lxorguk.ukuu.org.uk> wrote:
>> On Tue,  8 Mar 2016 13:47:55 -0700
>> Scott Bauer <sbauer@eng.utah.edu> wrote:
>>
>>> This patch adds a sysctl argument to disable SROP protection.
>>
>> Shouldn't it be a sysctl to enable it irrevocably, otherwise if I have DAC
>> capability I can turn off SROP and attack something to get to higher
>> capability levels ?
>>
>> (The way almost all distros are set up its kind of academic but for a
>> properly secured system it might matter).
>
> Perhaps use proc_dointvec_minmax_sysadmin instead to tie changes
> strictly to CAP_SYS_ADMIN?

I don't see why this needs to be irrevocable.  If you have
CAP_SYS_ADMIN or write access to /proc or whatever, you can do much
worse things than turning off a user-level mitigation.  For example,
you can ptrace things.  Also, you're already root, so what's the
point?

--Andy
