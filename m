Subject: Re: [PATCH] ima: drop vla in ima_audit_measurement()
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Date: Thu, 08 Mar 2018 13:50:30 -0500
In-Reply-To: <20180308183721.mnsrmhekyfo2dbso@smitten>
References: <20180308171456.2597-1-tycho@tycho.ws>
	 <CAHp75VfoiQ_PxBph8JnNzun4y5Z-9z_rUcjGyM7A2CAwynddeA@mail.gmail.com>
	 <20180308183721.mnsrmhekyfo2dbso@smitten>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-Id: <1520535030.3605.64.camel@linux.vnet.ibm.com>
To: Tycho Andersen <tycho@tycho.ws>, Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, linux-integrity@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 2018-03-08 at 11:37 -0700, Tycho Andersen wrote:
> On Thu, Mar 08, 2018 at 07:47:37PM +0200, Andy Shevchenko wrote:
> > On Thu, Mar 8, 2018 at 7:14 PM, Tycho Andersen <tycho@tycho.ws> wrote:
> > > In keeping with the directive to get rid of VLAs [1], let's drop the VLA
> > > from ima_audit_measurement(). We need to adjust the return type of
> > > ima_audit_measurement, because now this function can fail if an allocation
> > > fails.
> > 
> > 
> > 
> > > +       algo_hash_len = hash_len + strlen(algo_name) + 2;
> > > +       algo_hash = kzalloc(algo_hash_len, GFP_KERNEL);
> > 
> > > -       snprintf(algo_hash, sizeof(algo_hash), "%s:%s", algo_name, hash);
> > > +       snprintf(algo_hash, algo_hash_len, "%s:%s", algo_name, hash);
> > 
> > kasprintf() ?
> 
> Sure, in fact I think we could just do:
> 
> -	snprintf(algo_hash, algo_hash_len, "%s:%s", algo_name, hash);
> -	audit_log_untrustedstring(ab, algo_hash);
> +	audit_log_untrustedstring(ab, algo_name);
> +	audit_log_format(ab, ":");
> +	audit_log_untrustedstring(ab, hash);
> 
> and get rid of the allocation entirely. I'll test and make sure it
> works and then re-send.

The hash algorithm name is an enumeration that comes from the kernel.
 It's defined in crypto/hash_info.c: hash_algo_name.  Why do we need
to use audit_log_untrustedstring()?

Mimi
