Date: Fri, 21 Dec 2018 23:47:19 +0100
From: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Subject: Re: [RFC v1 0/4] static analysis of copy_to_user()
Message-ID: <20181221224717.zixqkz26xujllmq4@ltop.local>
References: <20181220195931.20331-1-tycho@tycho.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181220195931.20331-1-tycho@tycho.ws>
To: Tycho Andersen <tycho@tycho.ws>
Cc: linux-sparse@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Dec 20, 2018 at 12:59:27PM -0700, Tycho Andersen wrote:
> Hi all,
> 
> A while ago I talked with various people about whether some static
> analsys of copy_to_user() could be productive in finding infoleaks.
> Unfortunately, due to the various issues outlined in the patch notes, it
> doesn't seem like it is. Perhaps these checks are useful to put in just
> to future proof ourselves against these sorts of issues, though.
> 
> Anyway, here's the code. Thoughts welcome!

Hi,

I'm taking the first patch directly but I won't be able to look
closer at the other patches until next week.

Best regards,
-- Luc 
