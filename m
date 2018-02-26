Date: Sun, 25 Feb 2018 18:09:53 -0700
From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: [PATCH 4/4] leaking_addresses: add scan_once array
Message-ID: <20180226010953.37z3sz3rwcnj426k@cisco>
References: <1519008649-15782-1-git-send-email-me@tobin.cc>
 <1519008649-15782-5-git-send-email-me@tobin.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1519008649-15782-5-git-send-email-me@tobin.cc>
To: "Tobin C. Harding" <me@tobin.cc>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Tobin,

On Mon, Feb 19, 2018 at 01:50:49PM +1100, Tobin C. Harding wrote:
> +sub already_scanned
> +{
> +	my ($filename) = @_;
> +	state %seen;
> +
> +	foreach (@once_only) {
> +		if (/^$filename$/) {
> +			if ($seen{$_} == 1) {

This should be something like,

if (($seen{$_} //= 0) == 1) {

otherwise I get a bunch of uninitialized warnings,

Use of uninitialized value in pattern match (m//) at /usr/share/perl/5.26/Math/BigInt.pm line 1199.
    Math::BigInt::bcmp(Math::BigInt=HASH(0x55dc2f7e4580), undef) called at /usr/share/perl/5.26/Math/BigInt.pm line 1257
    Math::BigInt::beq(Math::BigInt=HASH(0x55dc2f7e4580), undef) called at /usr/share/perl/5.26/Math/BigInt.pm line 105
    Math::BigInt::__ANON__(Math::BigInt=HASH(0x55dc2f7e4580), undef, 1) called at ./leaking_addresses.pl line 422
    main::already_scanned("smaps") called at ./leaking_addresses.pl line 448
    main::skip("/proc/1/smaps") called at ./leaking_addresses.pl line 509
    main::walk("/proc", "/sys") called at ./leaking_addresses.pl line 159

Tycho
