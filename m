Date: Thu, 9 Nov 2017 22:46:46 -0600
From: "Serge E. Hallyn" <serge@hallyn.com>
Message-ID: <20171110044645.GA3694@mail.hallyn.com>
References: <CAFUG7CcEy9a=RxBQZJR-C_2VuhZXrzJ_QxJnrSxdM=ox36DsXQ@mail.gmail.com>
 <20171106233913.GA1518@mail.hallyn.com>
 <CAFUG7CcW077LHcQEqk7qy7iVvmi-3J8psD1Kwj45XvHThiZC6w@mail.gmail.com>
 <20171107032802.GA6669@mail.hallyn.com>
 <CAF2d9jiwu3Ss7Dtem8qSptKgMc0Mc_o8MAAJkWM5CwJaFsbrcg@mail.gmail.com>
 <20171108190223.vdkyepcaegmub6le@gmail.com>
 <CAF2d9jjed4Q7QvCD9Kpaa7L-Ngg3XFbJvt0jNVUUwt=52wDjjw@mail.gmail.com>
 <20171109032134.GA15666@mail.hallyn.com>
 <CAF2d9jgs5MYn1dMT2mbhF=6UB2Hoo5kwmJhXuE6memBfWzkWXQ@mail.gmail.com>
 <871sl7dsh8.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871sl7dsh8.fsf@xmission.com>
Subject: Re: [kernel-hardening] Re: [PATCH resend 2/2] userns: control
 capabilities of some user namespaces
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Mahesh Bandewar =?utf-8?B?KOCkruCkueClh+CktiDgpKzgpILgpKHgpYfgpLXgpL4=?= =?utf-8?B?4KSwKQ==?= <maheshb@google.com>, "Serge E. Hallyn" <serge@hallyn.com>, Christian Brauner <christian.brauner@canonical.com>, Boris Lukashev <blukashev@sempervictus.com>, Daniel Micay <danielmicay@gmail.com>, Mahesh Bandewar <mahesh@bandewar.net>, LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>, Kernel-hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Eric Dumazet <edumazet@google.com>, David Miller <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

Quoting Eric W. Biederman (ebiederm@xmission.com):
> single sandbox.  I am not at all certain that the capabilities is the
> proper place to limit code reachability.

Right, I keep having this gut feeling that there is another way we
should be doing that.  Maybe based on ksplice or perf, or maybe more
based on subsystems.  And I hope someone pursues that.  But I can't put
my finger on it, and meanwhile the capability checks obviously *are* in
fact gates...

-serge
