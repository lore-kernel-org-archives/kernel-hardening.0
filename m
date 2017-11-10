MIME-Version: 1.0
In-Reply-To: <20171110044645.GA3694@mail.hallyn.com>
References: <CAFUG7CcEy9a=RxBQZJR-C_2VuhZXrzJ_QxJnrSxdM=ox36DsXQ@mail.gmail.com>
 <20171106233913.GA1518@mail.hallyn.com> <CAFUG7CcW077LHcQEqk7qy7iVvmi-3J8psD1Kwj45XvHThiZC6w@mail.gmail.com>
 <20171107032802.GA6669@mail.hallyn.com> <CAF2d9jiwu3Ss7Dtem8qSptKgMc0Mc_o8MAAJkWM5CwJaFsbrcg@mail.gmail.com>
 <20171108190223.vdkyepcaegmub6le@gmail.com> <CAF2d9jjed4Q7QvCD9Kpaa7L-Ngg3XFbJvt0jNVUUwt=52wDjjw@mail.gmail.com>
 <20171109032134.GA15666@mail.hallyn.com> <CAF2d9jgs5MYn1dMT2mbhF=6UB2Hoo5kwmJhXuE6memBfWzkWXQ@mail.gmail.com>
 <871sl7dsh8.fsf@xmission.com> <20171110044645.GA3694@mail.hallyn.com>
From: =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= <maheshb@google.com>
Date: Fri, 10 Nov 2017 14:28:04 +0900
Message-ID: <CAF2d9jjLbN6TLZ2H888zku4Xupsqr-X66d7QCvtXsCzkyNFoDQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: [PATCH resend 2/2] userns: control
 capabilities of some user namespaces
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Christian Brauner <christian.brauner@canonical.com>, Boris Lukashev <blukashev@sempervictus.com>, Daniel Micay <danielmicay@gmail.com>, Mahesh Bandewar <mahesh@bandewar.net>, LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>, Kernel-hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Eric Dumazet <edumazet@google.com>, David Miller <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Nov 10, 2017 at 1:46 PM, Serge E. Hallyn <serge@hallyn.com> wrote:
> Quoting Eric W. Biederman (ebiederm@xmission.com):
>> single sandbox.  I am not at all certain that the capabilities is the
>> proper place to limit code reachability.
>
> Right, I keep having this gut feeling that there is another way we
> should be doing that.  Maybe based on ksplice or perf, or maybe more
> based on subsystems.  And I hope someone pursues that.  But I can't put
> my finger on it, and meanwhile the capability checks obviously *are* in
> fact gates...
>
Well, I don't mind if there is a better solution available. The
proposed solution is not adding too much or complex code and using a
bit and a sysctl and will be sitting dormant. When we have complete
solution, this addition should not be a burden to maintain because of
it's non-invasive footprint.

I will push the next version of the patch-set that implements Serge's finding.

Thanks,
--mahesh..

[PS: I'll be soon traveling again and moving to an area where
connectivity will be scarce / unreliable. So please expect lot more
delays in my responses.]

> -serge
