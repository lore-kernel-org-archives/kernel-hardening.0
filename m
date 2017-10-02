MIME-Version: 1.0
In-Reply-To: <20171002171410.GA19611@mail.hallyn.com>
References: <20170929230952.29673-1-mahesh@bandewar.net> <20171002171410.GA19611@mail.hallyn.com>
From: =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= <maheshb@google.com>
Date: Mon, 2 Oct 2017 11:12:09 -0700
Message-ID: <CAF2d9jjc6z_cO7co_C7L7xPujqA2npa2nXpUHZbE-Le6BSGFNg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] [PATCH 0/2] capability controlled user-namespaces
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Mahesh Bandewar <mahesh@bandewar.net>, LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>, Kernel-hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, Kees Cook <keescook@chromium.org>, "Eric W . Biederman" <ebiederm@xmission.com>, Eric Dumazet <edumazet@google.com>, David Miller <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Oct 2, 2017 at 10:14 AM, Serge E. Hallyn <serge@hallyn.com> wrote:
> Quoting Mahesh Bandewar (mahesh@bandewar.net):
>> From: Mahesh Bandewar <maheshb@google.com>
>>
>> [Same as the previous RFC series sent on 9/21]
>>
>> TL;DR version
>> -------------
>> Creating a sandbox environment with namespaces is challenging
>> considering what these sandboxed processes can engage into. e.g.
>> CVE-2017-6074, CVE-2017-7184, CVE-2017-7308 etc. just to name few.
>> Current form of user-namespaces, however, if changed a bit can allow
>> us to create a sandbox environment without locking down user-
>> namespaces.
>>
>> Detailed version
>> ----------------
>
> Hi,
>
> still struggling with how I feel about the idea in general.
>
> So is the intent mainly that if/when there comes an 0-day which allows
> users with CAP_NET_ADMIN in any namespace to gain privilege on the host,
> then this can be used as a stop-gap measure until there is a proper fix?
>
Thank for looking at this Serge.

Yes, but at the same time it's not just limited to NET_ADMIN but could
be any of the current capabilities.

> Otherwise, do you have any guidance for how people should use this?
>
> IMO it should be heavily discouraged to use this tool as a regular
> day to day configuration, as I'm not sure there is any "educated"
> decision to be made, even by those who are in the know, about what
> to put in this set.
>
I think that really depends on the environment. e.g. in certain
sandboxes third-part / semi-trusted workload is executed where network
resource is not used. In that environment I can easily take off
NET_ADMIN and NET_RAW without affecting anything there. At the same
time I wont have to worry about 0-day related to these two
capabilities. I would say the Admins at these places are in the best
place to decide what they can take-off safely and what they cannot.
Even if they decide not to take-off anything, having a tool at hand to
gain control is important when the next 0-day strikes us that can be
exploited using any of the currently used capabilities.

However, you are absolutely right in terms of using it as a stop-gap
measure to protect environment until it's fixed and the capability in
question can not be safely taken off permanently without hampering
operations.

thanks,
--mahesh..

[...]
