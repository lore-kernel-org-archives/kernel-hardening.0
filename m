Reply-To: kernel-hardening@lists.openwall.com
References: <565B7F7D.80208@nod.at>
 <CAGXu5jJqQKAmFK0nL69E0QOpo8WSVDqStGZo7-m7gy3vnXBa=A@mail.gmail.com>
From: Richard Weinberger <richard@nod.at>
Message-ID: <565CD5A4.4010106@nod.at>
Date: Tue, 1 Dec 2015 00:03:00 +0100
MIME-Version: 1.0
In-Reply-To: <CAGXu5jJqQKAmFK0nL69E0QOpo8WSVDqStGZo7-m7gy3vnXBa=A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: user controllable usermodehelper in br_stp_if.c
To: Kees Cook <keescook@chromium.org>, "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, bridge@lists.linux-foundation.org, Stephen Hemminger <stephen@networkplumber.org>, shayan@liveve.org
List-ID: <kernel-hardening.lists.openwall.com>

Am 30.11.2015 um 21:14 schrieb Kees Cook:
> On Sun, Nov 29, 2015 at 2:43 PM, Richard Weinberger <richard@nod.at> wrote:
>> Hi!
>>
>> By spawning new network and user namesapces an unprivileged user
>> is able to execute /sbin/bridge-stp within the initial mount namespace
>> with global root rights.
>> While this cannot directly be used to break out of a container or gain
>> global root rights it could be used by exploit writers as valuable building block.
>>
>> e.g.
>> $ unshare -U -r -n /bin/sh
>> $ brctl addbr br0
>> $ brctl stp br0 on # this will execute /sbin/bridge-stp
>>
>> As this mechanism clearly cannot work with containers and seems to be legacy code
>> I suggest not calling call_usermodehelper() at all if we're not in the initial user namespace.
>> What do you think?
> 
> I'm not familiar with how bridge-stp is expected to operate with a
> network namespace, but if it's meaningless, then yeah, that seems like
> a reasonable change. Can you send a patch? (Also, if it's legacy code,
> maybe it could be turned off entirely, not just for containers?)

Eric was faster than me. :-)

BTW: kernel.core_pattern is also worth a look.
If the pipe mode is used, "|/bin/core_tool", it will be executed in the
initial namespace and any user/container can trigger it.
Shayan reported that some weeks ago: https://lkml.org/lkml/2015/10/24/134

Thanks,
//richard
