MIME-Version: 1.0
In-Reply-To: <87po6qzycp.fsf@xmission.com>
References: <20180103072642.161742-1-mahesh@bandewar.net> <87po6qzycp.fsf@xmission.com>
From: =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= <maheshb@google.com>
Date: Wed, 3 Jan 2018 21:53:45 -0800
Message-ID: <CAF2d9jhB56O6dGVokRtU46sbvJk4891Oa6A86okWbWptcG=pMg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCHv4 0/2] capability controlled user-namespaces
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Mahesh Bandewar <mahesh@bandewar.net>, LKML <linux-kernel@vger.kernel.org>, James Morris <james.l.morris@oracle.com>, Netdev <netdev@vger.kernel.org>, Kernel-hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, Linux Security <linux-security-module@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Kees Cook <keescook@chromium.org>, Eric Dumazet <edumazet@google.com>, David Miller <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jan 3, 2018 at 8:44 AM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> Mahesh Bandewar <mahesh@bandewar.net> writes:
>
>> From: Mahesh Bandewar <maheshb@google.com>
>>
>> TL;DR version
>> -------------
>> Creating a sandbox environment with namespaces is challenging
>> considering what these sandboxed processes can engage into. e.g.
>> CVE-2017-6074, CVE-2017-7184, CVE-2017-7308 etc. just to name few.
>> Current form of user-namespaces, however, if changed a bit can allow
>> us to create a sandbox environment without locking down user-
>> namespaces.
>
> In other conversations it appears it has been pointed out that user
> namespaces are not necessarily safe under no_new_privs.  In theory
> user namespaces should be safe but in practice not so much.
>
> So let me ask.  Would your concerns be addressed if we simply made
> creation and joining of user namespaces impossible in a no_new_privs
> sandbox?
>
Isn't this another form of locking down user-ns similar to setting per
user-ns sysctl max_userns = 0?

Having said that, not allowing processes to create and/or attach
user-namespaces is going to be problematic and possibly a regression.
This (current) patchset doesn't do that. It allows users to create
user-ns's of any depth and number permitted by per-ns max_userns
sysctl. However one can decide what to take-off and what to leave in
terms of capabilities for the sandbox environment.

--mahesh..

> Eric
>
[...]
