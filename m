Reply-To: kernel-hardening@lists.openwall.com
References: <565B7F7D.80208@nod.at>
 <CAGXu5jJqQKAmFK0nL69E0QOpo8WSVDqStGZo7-m7gy3vnXBa=A@mail.gmail.com>
 <87egf7183c.fsf_-_@x220.int.ebiederm.org>
From: Richard Weinberger <richard@nod.at>
Message-ID: <565CD459.6010402@nod.at>
Date: Mon, 30 Nov 2015 23:57:29 +0100
MIME-Version: 1.0
In-Reply-To: <87egf7183c.fsf_-_@x220.int.ebiederm.org>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH net] bridge: Only call /sbin/bridge-stp for the initial
 network namespace
To: "Eric W. Biederman" <ebiederm@xmission.com>, David Miller <davem@davemloft.net>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, bridge@lists.linux-foundation.org, Stephen Hemminger <stephen@networkplumber.org>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

Am 30.11.2015 um 22:38 schrieb Eric W. Biederman:
> 
> There is no defined mechanism to pass network namespace information
> into /sbin/bridge-stp therefore don't even try to invoke it except
> for bridge devices in the initial network namespace.
> 
> It is possible for unprivileged users to cause /sbin/bridge-stp to be
> invoked for any network device name which if /sbin/bridge-stp does not
> guard against unreasonable arguments or being invoked twice on the same
> network device could cause problems.
> 
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

Just figured that /sbin/bridge-stp is a shell script.
Network interfaces can contain a lot of funny characters,
maybe this is after all a security issue.

Thanks,
//richard
