Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20151202.235049.2068953758962834535.davem@davemloft.net>
References: <565B7F7D.80208@nod.at>
	<CAGXu5jJqQKAmFK0nL69E0QOpo8WSVDqStGZo7-m7gy3vnXBa=A@mail.gmail.com>
	<87egf7183c.fsf_-_@x220.int.ebiederm.org>
	<20151202.235049.2068953758962834535.davem@davemloft.net>
Date: Tue, 8 Dec 2015 12:56:43 -0800
Message-ID: <CAGXu5jJJ-cYuckKPbmLejEZ82FY5eWR5R5MVRgxgTD+7hHZ1gg@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH net] bridge: Only call /sbin/bridge-stp for the initial
 network namespace
To: David Miller <davem@davemloft.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Richard Weinberger <richard@nod.at>, Network Development <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, bridge@lists.linux-foundation.org, Stephen Hemminger <stephen@networkplumber.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Dec 2, 2015 at 8:50 PM, David Miller <davem@davemloft.net> wrote:
> From: ebiederm@xmission.com (Eric W. Biederman)
> Date: Mon, 30 Nov 2015 15:38:15 -0600
>
>> +     if (dev_net(br->dev) == &init_net)
>
> Please respin this using net_eq() as Hannes pointed out.

Sorry if I missed it: this this happen yet?

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
