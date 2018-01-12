From: Christian Lamparter <chunkeey@gmail.com>
Date: Fri, 12 Jan 2018 21:01:59 +0100
Message-ID: <6067453.9oC6tc2YFn@debian64>
In-Reply-To: <CAPcyv4gne66ic3E-Y+pLi4QZdVeeeVmvayVPA3Jt1gyUqpaF9g@mail.gmail.com>
References: <151571798296.27429.7166552848688034184.stgit@dwillia2-desk3.amr.corp.intel.com> <1648304.tjl4HeBnOe@debian64> <CAPcyv4gne66ic3E-Y+pLi4QZdVeeeVmvayVPA3Jt1gyUqpaF9g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Subject: [kernel-hardening] Re: [PATCH v2 15/19] carl9170: prevent bounds-check bypass via speculative execution
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, kernel-hardening@lists.openwall.com, Netdev <netdev@vger.kernel.org>, Linux Wireless List <linux-wireless@vger.kernel.org>, Elena Reshetova <elena.reshetova@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Kalle Valo <kvalo@codeaurora.org>, Alan Cox <alan@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Friday, January 12, 2018 7:39:50 PM CET Dan Williams wrote:
> On Fri, Jan 12, 2018 at 6:42 AM, Christian Lamparter <chunkeey@gmail.com> wrote:
> > On Friday, January 12, 2018 1:47:46 AM CET Dan Williams wrote:
> >> Static analysis reports that 'queue' may be a user controlled value that
> >> is used as a data dependency to read from the 'ar9170_qmap' array. In
> >> order to avoid potential leaks of kernel memory values, block
> >> speculative execution of the instruction stream that could issue reads
> >> based on an invalid result of 'ar9170_qmap[queue]'. In this case the
> >> value of 'ar9170_qmap[queue]' is immediately reused as an index to the
> >> 'ar->edcf' array.
> >>
> >> Based on an original patch by Elena Reshetova.
> >>
> >> Cc: Christian Lamparter <chunkeey@googlemail.com>
> >> Cc: Kalle Valo <kvalo@codeaurora.org>
> >> Cc: linux-wireless@vger.kernel.org
> >> Cc: netdev@vger.kernel.org
> >> Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
> >> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> >> ---
> > This patch (and p54, cw1200) look like the same patch?!
> > Can you tell me what happend to:
> >
> > On Saturday, January 6, 2018 5:34:03 PM CET Dan Williams wrote:
> >> On Sat, Jan 6, 2018 at 6:23 AM, Christian Lamparter <chunkeey@gmail.com> wrote:
> >> > And Furthermore a invalid queue (param->ac) would cause a crash in
> >> > this line in mac80211 before it even reaches the driver [1]:
> >> > |       sdata->tx_conf[params->ac] = p;
> >> > |                   ^^^^^^^^
> >> > |       if (drv_conf_tx(local, sdata, >>>> params->ac <<<<, &p)) {
> >> > |        ^^ (this is a wrapper for the *_op_conf_tx)
> >> >
> >> > I don't think these chin-up exercises are needed.
> >>
> >> Quite the contrary, you've identified a better place in the call stack
> >> to sanitize the input and disable speculation. Then we can kill the
> >> whole class of the wireless driver reports at once it seems.
> > <https://www.spinics.net/lists/netdev/msg476353.html>
> 
> I didn't see where ac is being validated against the driver specific
> 'queues' value in that earlier patch.
The link to the check is right there in the earlier post. It's in 
parse_txq_params():
<https://github.com/torvalds/linux/blob/master/net/wireless/nl80211.c#L2070>
|	if (txq_params->ac >= NL80211_NUM_ACS)
|		return -EINVAL;

NL80211_NUM_ACS is 4
<http://elixir.free-electrons.com/linux/v4.15-rc7/source/include/uapi/linux/nl80211.h#L3748>

This check was added ever since mac80211's ieee80211_set_txq_params():
| sdata->tx_conf[params->ac] = p;

For cw1200: the driver just sets the dev->queue to 4.
In carl9170 dev->queues is set to __AR9170_NUM_TXQ and
p54 uses P54_QUEUE_AC_NUM.

Both __AR9170_NUM_TXQ and P54_QUEUE_AC_NUM are 4.
And this is not going to change since all drivers
have to follow mac80211's queue API:
<https://wireless.wiki.kernel.org/en/developers/documentation/mac80211/queues>

Some background:
In the old days (linux 2.6 and early 3.x), the parse_txq_params() function did
not verify the "queue" value. That's why these drivers had to do it.

Here's the relevant code from 2.6.39:
<http://elixir.free-electrons.com/linux/v2.6.39/source/net/wireless/nl80211.c#L879>
You'll notice that the check is missing there.
Here's mac80211's ieee80211_set_txq_params for reference:
<http://elixir.free-electrons.com/linux/v2.6.39/source/net/mac80211/cfg.c#L1197>

However over time, the check in the driver has become redundant.

> > Anyway, I think there's an easy way to solve this: remove the
> > "if (queue < ar->hw->queues)" check altogether. It's no longer needed
> > anymore as the "queue" value is validated long before the driver code
> > gets called.
> > 
> > And from my understanding, this will fix the "In this case
> > the value of 'ar9170_qmap[queue]' is immediately reused as an index to
> > the 'ar->edcf' array." gripe your tool complains about.
> >
> > This is here's a quick test-case for carl9170.:
> > ---
> > diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
> > index 988c8857d78c..2d3afb15bb62 100644
> > --- a/drivers/net/wireless/ath/carl9170/main.c
> > +++ b/drivers/net/wireless/ath/carl9170/main.c
> > @@ -1387,13 +1387,8 @@ static int carl9170_op_conf_tx(struct ieee80211_hw *hw,
> >         int ret;
> >
> >         mutex_lock(&ar->mutex);
> > -       if (queue < ar->hw->queues) {
> > -               memcpy(&ar->edcf[ar9170_qmap[queue]], param, sizeof(*param));
> > -               ret = carl9170_set_qos(ar);
> > -       } else {
> > -               ret = -EINVAL;
> > -       }
> > -
> > +       memcpy(&ar->edcf[ar9170_qmap[queue]], param, sizeof(*param));
> > +       ret = carl9170_set_qos(ar);
> >         mutex_unlock(&ar->mutex);
> >         return ret;
> >  }
> > ---
> > What does your tool say about this?
> 
> If you take away the 'if' then I don't the tool will report on this.
> 
> > (If necessary, the "queue" value could be even sanitized with a
> > queue %= ARRAY_SIZE(ar9170_qmap); before the mutex_lock.)
> 
> That is what array_ptr() is doing in a more sophisticated way.
I think it's a very roundabout way :D. In any case the queue %= ...
could also be replaced by:
BUILD_BUG_ON(ARRAY_SIZE(ar9170_qmap) != NL80211_NUM_ACS));
(And the equivalent for p54, cw1200)
