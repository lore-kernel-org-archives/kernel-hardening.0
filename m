Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CALCETrWYRvqhyCwx5RX6L3TEYCfW0j6ThFUc+ASL7BpxgO5dEQ@mail.gmail.com>
References: <1453502345-30416-1-git-send-email-keescook@chromium.org>
	<8737tp0zhr.fsf@x220.int.ebiederm.org>
	<CALCETrWYRvqhyCwx5RX6L3TEYCfW0j6ThFUc+ASL7BpxgO5dEQ@mail.gmail.com>
Date: Mon, 25 Jan 2016 10:51:49 -0800
Message-ID: <CAGXu5j+mx+6BOKb42yfyKnL7VTCUBNC0Nk9aCOd0D5tSD6DbCg@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH 0/2] sysctl: allow CLONE_NEWUSER to be disabled
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Richard Weinberger <richard@nod.at>, =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>, Dmitry Vyukov <dvyukov@google.com>, David Howells <dhowells@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>, Kostya Serebryany <kcc@google.com>, Alexander Potapenko <glider@google.com>, Eric Dumazet <edumazet@google.com>, Sasha Levin <sasha.levin@oracle.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Jan 24, 2016 at 2:22 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Fri, Jan 22, 2016 at 7:02 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>> Kees Cook <keescook@chromium.org> writes:
>>
>>> There continues to be unexpected side-effects and security exposures
>>> via CLONE_NEWUSER. For many end-users running distro kernels with
>>> CONFIG_USER_NS enabled, there is no way to disable this feature when
>>> desired. As such, this creates a sysctl to restrict CLONE_NEWUSER so
>>> admins not running containers or Chrome can avoid the risks of this
>>> feature.
>>
>> I don't actually think there do continue to be unexpected side-effects
>> and security exposures with CLONE_NEWUSER.  It takes a while for all of
>> the fixes to trickle out to distros.  At most what I have seen recently
>> are problems with other kernel interfaces being amplified with user
>> namespaces.  AKA the current mess with devpts, and the unexpected
>> issues with bind mounts in mount namespaces.
>>
>
>>
>> So to keep this productive.  Please tell me about the threat model
>> you envision, and how you envision knobs in the kernel being used to
>> counter those threats.
>
> I consider the ability to use CLONE_NEWUSER to acquire CAP_NET_ADMIN
> over /any/ network namespace and to thus access the network
> configuration API to be a huge risk.  For example, unprivileged users
> can program iptables.  I'll eat my hat if there are no privilege
> escalations in there.  (They can't request module loading, but still.)

Should I consider this an Ack for the patch? :)

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
