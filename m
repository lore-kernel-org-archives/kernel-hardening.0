Return-Path: <SRS0=i4+8=52=lists.openwall.com=kernel-hardening-return-18487-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4213FC2BA2B
	for <kernel-hardening@archiver.kernel.org>; Fri, 10 Apr 2020 10:13:30 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C784520757
	for <kernel-hardening@archiver.kernel.org>; Fri, 10 Apr 2020 10:13:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C784520757
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18487-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15916 invoked by uid 550); 10 Apr 2020 10:13:02 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17936 invoked from network); 10 Apr 2020 02:28:24 -0000
IronPort-SDR: OlJZM54g4dAnG5oL1wx3IqZJ9uivZG2TI96qg4sPWKNyuUicCt2P0nndfvvPzEwpJ5gZN4eWGq
 C/xDr8J+pA8g==
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
IronPort-SDR: BR2uRvy2wXxz+0h9B3Ru65wtfKm1EOciFbnhGYc5mKW0PF8XkUWItY2ttv+OALHglK/+YcLG8h
 qtKg7UmuWAIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,364,1580803200"; 
   d="xz'?yaml'?scan'208";a="398794755"
Date: Fri, 10 Apr 2020 10:27:39 +0800
From: kernel test robot <rong.a.chen@intel.com>
To: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
Cc: linux-kernel@vger.kernel.org,
	=?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Arnd Bergmann <arnd@arndb.de>,
	Casey Schaufler <casey@schaufler-ca.com>,
	James Morris <jmorris@namei.org>, Jann Horn <jann@thejh.net>,
	Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>,
	Michael Kerrisk <mtk.manpages@gmail.com>,
	=?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mickael.salaun@ssi.gouv.fr>,
	"Serge E . Hallyn" <serge@hallyn.com>,
	Shuah Khan <shuah@kernel.org>,
	Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>,
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-security-module@vger.kernel.org, x86@kernel.org,
	lkp@lists.01.org
Subject: [selftests/landlock] d9d464ccf6:
 kernel-selftests.landlock.test_base.fail
Message-ID: <20200410022739.GK8179@shao2-debian>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="lKbk9CFItQTD29wm"
Content-Disposition: inline
In-Reply-To: <20200326202731.693608-9-mic@digikod.net>
User-Agent: NeoMutt/20170113 (1.7.2)


--lKbk9CFItQTD29wm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

FYI, we noticed the following commit (built with gcc-7):

commit: d9d464ccf68e19bf7d303022d873141b5e1f7219 ("[PATCH v15 08/10] selftests/landlock: Add initial tests")
url: https://github.com/0day-ci/linux/commits/Micka-l-Sala-n/Landlock-LSM/20200327-073729
base: https://git.kernel.org/cgit/linux/kernel/git/shuah/linux-kselftest.git next

in testcase: kernel-selftests
with following parameters:

	group: kselftests-01
	ucode: 0xd6

test-description: The kernel contains a set of "self tests" under the tools/testing/selftests/ directory. These are intended to be small unit tests to exercise individual code paths in the kernel.
test-url: https://www.kernel.org/doc/Documentation/kselftest.txt


on test machine: 8 threads Intel(R) Core(TM) i7-6700 CPU @ 3.40GHz with 16G memory

caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):


If you fix the issue, kindly add following tag
Reported-by: kernel test robot <rong.a.chen@intel.com>


2020-04-09 08:20:02 make run_tests -C landlock
make: Entering directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/landlock'
make --no-builtin-rules ARCH=x86 -C ../../../.. headers_install
make[1]: Entering directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219'
  INSTALL ./usr/include
make[1]: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219'
gcc -Wall -O2 -I../../../../usr/include    test_base.c /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kselftest_harness.h /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kselftest.h ../../../../usr/include/linux/landlock.h ../kselftest_harness.h common.h  -o /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/landlock/test_base
gcc -Wall -O2 -I../../../../usr/include    test_ptrace.c /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kselftest_harness.h /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kselftest.h ../../../../usr/include/linux/landlock.h ../kselftest_harness.h common.h  -o /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/landlock/test_ptrace
gcc -Wall -O2 -I../../../../usr/include    test_fs.c /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kselftest_harness.h /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kselftest.h ../../../../usr/include/linux/landlock.h ../kselftest_harness.h common.h  -o /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/landlock/test_fs
gcc -Os -static -o /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/landlock/true true.c
TAP version 13
1..3
# selftests: landlock: test_base
# common.h:37:ruleset_rw.fdinfo:Expected 0 (0) <= self->ruleset_fd (18446744073709551615)
# ruleset_rw.fdinfo: Test terminated by assertion
# test_base.c:64:global.features:Expected 0 (0) == landlock(LANDLOCK_CMD_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_features), &attr_features) (18446744073709551615)
# global.features: Test terminated by assertion
# test_base.c:89:global.empty_attr_ruleset:Expected errno (38) == EINVAL (22)
# global.empty_attr_ruleset: Test terminated by assertion
# test_base.c:99:global.empty_attr_path_beneath:Expected errno (38) == EINVAL (22)
# global.empty_attr_path_beneath: Test terminated by assertion
# test_base.c:109:global.empty_attr_enforce:Expected errno (38) == EINVAL (22)
# global.empty_attr_enforce: Test terminated by assertion
# [==========] Running 5 tests from 2 test cases.
# [ RUN      ] ruleset_rw.fdinfo
# [     FAIL ] ruleset_rw.fdinfo
# [ RUN      ] global.features
# [     FAIL ] global.features
# [ RUN      ] global.empty_attr_ruleset
# [     FAIL ] global.empty_attr_ruleset
# [ RUN      ] global.empty_attr_path_beneath
# [     FAIL ] global.empty_attr_path_beneath
# [ RUN      ] global.empty_attr_enforce
# [     FAIL ] global.empty_attr_enforce
# [==========] 0 / 5 tests passed.
# [  FAILED  ]
not ok 1 selftests: landlock: test_base # exit=1
# selftests: landlock: test_ptrace
# test_ptrace.c:36:global.allow_with_one_domain:Expected 0 (0) == landlock(LANDLOCK_CMD_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_features), &attr_features) (18446744073709551615)
# test_ptrace.c:148:global.allow_with_one_domain:Expected 1 (1) == read(pipe_child[0], &buf_parent, 1) (0)
# test_ptrace.c:149:global.allow_with_one_domain:Failed to read() sync #2 from child
# global.allow_with_one_domain: Test terminated by assertion
# test_ptrace.c:36:global.deny_with_parent_domain:Expected 0 (0) == landlock(LANDLOCK_CMD_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_features), &attr_features) (18446744073709551615)
# test_ptrace.c:99:global.deny_with_parent_domain:Expected 1 (1) == read(pipe_parent[0], &buf_child, 1) (0)
# test_ptrace.c:100:global.deny_with_parent_domain:Failed to read() sync #1 from parent
# global.deny_with_parent_domain: Test terminated by assertion
# test_ptrace.c:36:global.deny_with_sibling_domain:Expected 0 (0) == landlock(LANDLOCK_CMD_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_features), &attr_features) (18446744073709551615)
# test_ptrace.c:36:global.deny_with_sibling_domain:Expected 0 (0) == landlock(LANDLOCK_CMD_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_features), &attr_features) (18446744073709551615)
# global.deny_with_sibling_domain: Test terminated by assertion
# test_ptrace.c:36:global.allow_sibling_domain:Expected 0 (0) == landlock(LANDLOCK_CMD_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_features), &attr_features) (18446744073709551615)
# global.allow_sibling_domain: Test terminated by assertion
# test_ptrace.c:36:global.allow_with_nested_domain:Expected 0 (0) == landlock(LANDLOCK_CMD_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_features), &attr_features) (18446744073709551615)
# global.allow_with_nested_domain: Test terminated by assertion
# test_ptrace.c:36:global.deny_with_nested_and_parent_domain:Expected 0 (0) == landlock(LANDLOCK_CMD_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_features), &attr_features) (18446744073709551615)
# global.deny_with_nested_and_parent_domain: Test terminated by assertion
# test_ptrace.c:36:global.deny_with_forked_domain:Expected 0 (0) == landlock(LANDLOCK_CMD_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_features), &attr_features) (18446744073709551615)
# global.deny_with_forked_domain: Test terminated by assertion
# [==========] Running 8 tests from 2 test cases.
# [ RUN      ] global.allow_without_domain
# [       OK ] global.allow_without_domain
# [ RUN      ] global.allow_with_one_domain
# [     FAIL ] global.allow_with_one_domain
# [ RUN      ] global.deny_with_parent_domain
# [     FAIL ] global.deny_with_parent_domain
# [ RUN      ] global.deny_with_sibling_domain
# [     FAIL ] global.deny_with_sibling_domain
# [ RUN      ] global.allow_sibling_domain
# [     FAIL ] global.allow_sibling_domain
# [ RUN      ] global.allow_with_nested_domain
# [     FAIL ] global.allow_with_nested_domain
# [ RUN      ] global.deny_with_nested_and_parent_domain
# [     FAIL ] global.deny_with_nested_and_parent_domain
# [ RUN      ] global.deny_with_forked_domain
# [     FAIL ] global.deny_with_forked_domain
# [==========] 1 / 8 tests passed.
# [  FAILED  ]
not ok 2 selftests: landlock: test_ptrace # exit=1
# selftests: landlock: test_fs
# common.h:37:ruleset_rw.inval:Expected 0 (0) <= self->ruleset_fd (18446744073709551615)
# ruleset_rw.inval: Test terminated by assertion
# common.h:37:ruleset_rw.nsfs:Expected 0 (0) <= self->ruleset_fd (18446744073709551615)
# ruleset_rw.nsfs: Test terminated by assertion
# test_fs.c:342:layout1.whitelist:Expected 0 (0) == landlock(LANDLOCK_CMD_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_features), &attr_features) (18446744073709551615)
# layout1.whitelist: Test terminated by assertion
# test_fs.c:342:layout1.unhandled_access:Expected 0 (0) == landlock(LANDLOCK_CMD_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_features), &attr_features) (18446744073709551615)
# layout1.unhandled_access: Test terminated by assertion
# test_fs.c:342:layout1.ruleset_overlap:Expected 0 (0) == landlock(LANDLOCK_CMD_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_features), &attr_features) (18446744073709551615)
# layout1.ruleset_overlap: Test terminated by assertion
# test_fs.c:342:layout1.inherit_superset:Expected 0 (0) == landlock(LANDLOCK_CMD_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_features), &attr_features) (18446744073709551615)
# layout1.inherit_superset: Test terminated by assertion
# test_fs.c:342:layout1.rule_on_mountpoint:Expected 0 (0) == landlock(LANDLOCK_CMD_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_features), &attr_features) (18446744073709551615)
# layout1.rule_on_mountpoint: Test terminated by assertion
# test_fs.c:342:layout1.rule_over_mountpoint:Expected 0 (0) == landlock(LANDLOCK_CMD_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_features), &attr_features) (18446744073709551615)
# layout1.rule_over_mountpoint: Test terminated by assertion
# test_fs.c:342:layout1.rule_over_root:Expected 0 (0) == landlock(LANDLOCK_CMD_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_features), &attr_features) (18446744073709551615)
# layout1.rule_over_root: Test terminated by assertion
# test_fs.c:720:layout1.rule_inside_mount_ns:Expected -1 (18446744073709551615) != syscall(SYS_pivot_root, dir_s3d2, dir_s3d3) (18446744073709551615)
# test_fs.c:722:layout1.rule_inside_mount_ns:Failed to pivot_root into "tmp/s3d1/s3d2": Invalid argument
# 
# layout1.rule_inside_mount_ns: Test terminated by assertion
# test_fs.c:342:layout1.mount_and_pivot:Expected 0 (0) == landlock(LANDLOCK_CMD_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_features), &attr_features) (18446744073709551615)
# layout1.mount_and_pivot: Test terminated by assertion
# test_fs.c:342:layout1.relative_open:Expected 0 (0) == landlock(LANDLOCK_CMD_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_features), &attr_features) (18446744073709551615)
# layout1.relative_open: Test terminated by assertion
# test_fs.c:342:layout1.relative_chdir:Expected 0 (0) == landlock(LANDLOCK_CMD_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_features), &attr_features) (18446744073709551615)
# layout1.relative_chdir: Test terminated by assertion
# test_fs.c:342:layout1.relative_chroot_only:Expected 0 (0) == landlock(LANDLOCK_CMD_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_features), &attr_features) (18446744073709551615)
# layout1.relative_chroot_only: Test terminated by assertion
# test_fs.c:342:layout1.relative_chroot_chdir:Expected 0 (0) == landlock(LANDLOCK_CMD_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_features), &attr_features) (18446744073709551615)
# layout1.relative_chroot_chdir: Test terminated by assertion
# test_fs.c:342:layout1.chroot:Expected 0 (0) == landlock(LANDLOCK_CMD_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_features), &attr_features) (18446744073709551615)
# layout1.chroot: Test terminated by assertion
# test_fs.c:342:layout1.execute:Expected 0 (0) == landlock(LANDLOCK_CMD_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_features), &attr_features) (18446744073709551615)
# layout1.execute: Test terminated by assertion
# test_fs.c:342:layout1.link_to:Expected 0 (0) == landlock(LANDLOCK_CMD_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_features), &attr_features) (18446744073709551615)
# layout1.link_to: Test terminated by assertion
# test_fs.c:342:layout1.rename_from:Expected 0 (0) == landlock(LANDLOCK_CMD_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_features), &attr_features) (18446744073709551615)
# layout1.rename_from: Test terminated by assertion
# test_fs.c:342:layout1.rename_to:Expected 0 (0) == landlock(LANDLOCK_CMD_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_features), &attr_features) (18446744073709551615)
# layout1.rename_to: Test terminated by assertion
# test_fs.c:342:layout1.rmdir:Expected 0 (0) == landlock(LANDLOCK_CMD_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_features), &attr_features) (18446744073709551615)
# layout1.rmdir: Test terminated by assertion
# test_fs.c:342:layout1.unlink:Expected 0 (0) == landlock(LANDLOCK_CMD_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_features), &attr_features) (18446744073709551615)
# layout1.unlink: Test terminated by assertion
# test_fs.c:342:layout1.make_char:Expected 0 (0) == landlock(LANDLOCK_CMD_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_features), &attr_features) (18446744073709551615)
# layout1.make_char: Test terminated by assertion
# test_fs.c:342:layout1.make_block:Expected 0 (0) == landlock(LANDLOCK_CMD_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_features), &attr_features) (18446744073709551615)
# layout1.make_block: Test terminated by assertion
# test_fs.c:342:layout1.make_reg:Expected 0 (0) == landlock(LANDLOCK_CMD_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_features), &attr_features) (18446744073709551615)
# layout1.make_reg: Test terminated by assertion
# test_fs.c:342:layout1.make_sock:Expected 0 (0) == landlock(LANDLOCK_CMD_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_features), &attr_features) (18446744073709551615)
# layout1.make_sock: Test terminated by assertion
# test_fs.c:342:layout1.make_fifo:Expected 0 (0) == landlock(LANDLOCK_CMD_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_features), &attr_features) (18446744073709551615)
# layout1.make_fifo: Test terminated by assertion
# test_fs.c:342:layout1.make_sym:Expected 0 (0) == landlock(LANDLOCK_CMD_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_features), &attr_features) (18446744073709551615)
# layout1.make_sym: Test terminated by assertion
# test_fs.c:342:layout1.make_dir:Expected 0 (0) == landlock(LANDLOCK_CMD_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_features), &attr_features) (18446744073709551615)
# layout1.make_dir: Test terminated by assertion
# [==========] Running 31 tests from 3 test cases.
# [ RUN      ] layout1.no_restriction
# [       OK ] layout1.no_restriction
# [ RUN      ] ruleset_rw.inval
# [     FAIL ] ruleset_rw.inval
# [ RUN      ] ruleset_rw.nsfs
# [     FAIL ] ruleset_rw.nsfs
# [ RUN      ] layout1.whitelist
# [     FAIL ] layout1.whitelist
# [ RUN      ] layout1.unhandled_access
# [     FAIL ] layout1.unhandled_access
# [ RUN      ] layout1.ruleset_overlap
# [     FAIL ] layout1.ruleset_overlap
# [ RUN      ] layout1.inherit_superset
# [     FAIL ] layout1.inherit_superset
# [ RUN      ] layout1.rule_on_mountpoint
# [     FAIL ] layout1.rule_on_mountpoint
# [ RUN      ] layout1.rule_over_mountpoint
# [     FAIL ] layout1.rule_over_mountpoint
# [ RUN      ] layout1.rule_over_root
# [     FAIL ] layout1.rule_over_root
# [ RUN      ] layout1.rule_inside_mount_ns
# [     FAIL ] layout1.rule_inside_mount_ns
# [ RUN      ] layout1.mount_and_pivot
# [     FAIL ] layout1.mount_and_pivot
# [ RUN      ] layout1.relative_open
# [     FAIL ] layout1.relative_open
# [ RUN      ] layout1.relative_chdir
# [     FAIL ] layout1.relative_chdir
# [ RUN      ] layout1.relative_chroot_only
# [     FAIL ] layout1.relative_chroot_only
# [ RUN      ] layout1.relative_chroot_chdir
# [     FAIL ] layout1.relative_chroot_chdir
# [ RUN      ] layout1.chroot
# [     FAIL ] layout1.chroot
# [ RUN      ] layout1.execute
# [     FAIL ] layout1.execute
# [ RUN      ] layout1.link_to
# [     FAIL ] layout1.link_to
# [ RUN      ] layout1.rename_from
# [     FAIL ] layout1.rename_from
# [ RUN      ] layout1.rename_to
# [     FAIL ] layout1.rename_to
# [ RUN      ] layout1.rmdir
# [     FAIL ] layout1.rmdir
# [ RUN      ] layout1.unlink
# [     FAIL ] layout1.unlink
# [ RUN      ] layout1.make_char
# [     FAIL ] layout1.make_char
# [ RUN      ] layout1.make_block
# [     FAIL ] layout1.make_block
# [ RUN      ] layout1.make_reg
# [     FAIL ] layout1.make_reg
# [ RUN      ] layout1.make_sock
# [     FAIL ] layout1.make_sock
# [ RUN      ] layout1.make_fifo
# [     FAIL ] layout1.make_fifo
# [ RUN      ] layout1.make_sym
# [     FAIL ] layout1.make_sym
# [ RUN      ] layout1.make_dir
# [     FAIL ] layout1.make_dir
# [ RUN      ] global.cleanup
# [       OK ] global.cleanup
# [==========] 2 / 31 tests passed.
# [  FAILED  ]
not ok 3 selftests: landlock: test_fs # exit=1
make: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/landlock'



To reproduce:

        git clone https://github.com/intel/lkp-tests.git
        cd lkp-tests
        bin/lkp install job.yaml  # job file is attached in this email
        bin/lkp run     job.yaml



Thanks,
Rong Chen


--lKbk9CFItQTD29wm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-5.6.0-rc1-00033-gd9d464ccf68e1"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 5.6.0-rc1 Kernel Configuration
#

#
# Compiler: gcc-7 (Ubuntu 7.5.0-6ubuntu2) 7.5.0
#
CONFIG_CC_IS_GCC=y
CONFIG_GCC_VERSION=70500
CONFIG_CLANG_VERSION=0
CONFIG_CC_CAN_LINK=y
CONFIG_CC_HAS_ASM_GOTO=y
CONFIG_CC_HAS_ASM_INLINE=y
CONFIG_CC_HAS_WARN_MAYBE_UNINITIALIZED=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_TABLE_SORT=y
CONFIG_THREAD_INFO_IN_TASK=y

#
# General setup
#
CONFIG_INIT_ENV_ARG_LIMIT=32
# CONFIG_COMPILE_TEST is not set
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_BUILD_SALT=""
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_HAVE_KERNEL_LZ4=y
CONFIG_KERNEL_GZIP=y
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
# CONFIG_KERNEL_LZ4 is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_USELIB=y
CONFIG_AUDIT=y
CONFIG_HAVE_ARCH_AUDITSYSCALL=y
CONFIG_AUDITSYSCALL=y

#
# IRQ subsystem
#
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_IRQ_EFFECTIVE_AFF_MASK=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_IRQ_MIGRATION=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_SIM=y
CONFIG_IRQ_DOMAIN_HIERARCHY=y
CONFIG_GENERIC_MSI_IRQ=y
CONFIG_GENERIC_MSI_IRQ_DOMAIN=y
CONFIG_IRQ_MSI_IOMMU=y
CONFIG_GENERIC_IRQ_MATRIX_ALLOCATOR=y
CONFIG_GENERIC_IRQ_RESERVATION_MODE=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
# CONFIG_GENERIC_IRQ_DEBUGFS is not set
# end of IRQ subsystem

CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_ARCH_CLOCKSOURCE_INIT=y
CONFIG_CLOCKSOURCE_VALIDATE_LAST_CYCLE=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ_COMMON=y
# CONFIG_HZ_PERIODIC is not set
# CONFIG_NO_HZ_IDLE is not set
CONFIG_NO_HZ_FULL=y
CONFIG_CONTEXT_TRACKING=y
# CONFIG_CONTEXT_TRACKING_FORCE is not set
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
# end of Timers subsystem

# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y

#
# CPU/Task time and stats accounting
#
CONFIG_VIRT_CPU_ACCOUNTING=y
CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_HAVE_SCHED_AVG_IRQ=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
# CONFIG_PSI is not set
# end of CPU/Task time and stats accounting

CONFIG_CPU_ISOLATION=y

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_RCU_EXPERT is not set
CONFIG_SRCU=y
CONFIG_TREE_SRCU=y
CONFIG_TASKS_RCU=y
CONFIG_RCU_STALL_COMMON=y
CONFIG_RCU_NEED_SEGCBLIST=y
CONFIG_RCU_NOCB_CPU=y
# end of RCU Subsystem

CONFIG_BUILD_BIN2C=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
# CONFIG_IKHEADERS is not set
CONFIG_LOG_BUF_SHIFT=20
CONFIG_LOG_CPU_MAX_BUF_SHIFT=12
CONFIG_PRINTK_SAFE_LOG_BUF_SHIFT=13
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y

#
# Scheduler features
#
# end of Scheduler features

CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH=y
CONFIG_CC_HAS_INT128=y
CONFIG_ARCH_SUPPORTS_INT128=y
CONFIG_NUMA_BALANCING=y
CONFIG_NUMA_BALANCING_DEFAULT_ENABLED=y
CONFIG_CGROUPS=y
CONFIG_PAGE_COUNTER=y
CONFIG_MEMCG=y
CONFIG_MEMCG_SWAP=y
CONFIG_MEMCG_SWAP_ENABLED=y
CONFIG_MEMCG_KMEM=y
CONFIG_BLK_CGROUP=y
CONFIG_CGROUP_WRITEBACK=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_CFS_BANDWIDTH=y
CONFIG_RT_GROUP_SCHED=y
CONFIG_CGROUP_PIDS=y
CONFIG_CGROUP_RDMA=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_HUGETLB=y
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_BPF=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_SOCK_CGROUP_DATA=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_TIME_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_RD_LZ4=y
CONFIG_BOOT_CONFIG=y
CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE=y
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_HAVE_UID16=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_HAVE_PCSPKR_PLATFORM=y
CONFIG_BPF=y
CONFIG_EXPERT=y
CONFIG_UID16=y
CONFIG_MULTIUSER=y
CONFIG_SGETMASK_SYSCALL=y
CONFIG_SYSFS_SYSCALL=y
CONFIG_FHANDLE=y
CONFIG_POSIX_TIMERS=y
CONFIG_PRINTK=y
CONFIG_PRINTK_NMI=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_FUTEX_PI=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_IO_URING=y
CONFIG_ADVISE_SYSCALLS=y
CONFIG_MEMBARRIER=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_ABSOLUTE_PERCPU=y
CONFIG_KALLSYMS_BASE_RELATIVE=y
CONFIG_BPF_SYSCALL=y
CONFIG_ARCH_WANT_DEFAULT_BPF_JIT=y
CONFIG_BPF_JIT_ALWAYS_ON=y
CONFIG_BPF_JIT_DEFAULT_ON=y
CONFIG_USERFAULTFD=y
CONFIG_ARCH_HAS_MEMBARRIER_SYNC_CORE=y
CONFIG_RSEQ=y
# CONFIG_DEBUG_RSEQ is not set
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y
# CONFIG_PC104 is not set

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
# end of Kernel Performance Events And Counters

CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_SLUB_MEMCG_SYSFS_ON is not set
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_SLAB_MERGE_DEFAULT=y
# CONFIG_SLAB_FREELIST_RANDOM is not set
# CONFIG_SLAB_FREELIST_HARDENED is not set
# CONFIG_SHUFFLE_PAGE_ALLOCATOR is not set
CONFIG_SLUB_CPU_PARTIAL=y
CONFIG_SYSTEM_DATA_VERIFICATION=y
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
# end of General setup

CONFIG_64BIT=y
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_MMU=y
CONFIG_ARCH_MMAP_RND_BITS_MIN=28
CONFIG_ARCH_MMAP_RND_BITS_MAX=32
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MIN=8
CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MAX=16
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_FILTER_PGPROT=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_HAVE_INTEL_TXT=y
CONFIG_X86_64_SMP=y
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_DYNAMIC_PHYSICAL_MASK=y
CONFIG_PGTABLE_LEVELS=5
CONFIG_CC_HAS_SANE_STACKPROTECTOR=y

#
# Processor type and features
#
CONFIG_ZONE_DMA=y
CONFIG_SMP=y
CONFIG_X86_FEATURE_NAMES=y
CONFIG_X86_X2APIC=y
CONFIG_X86_MPPARSE=y
# CONFIG_GOLDFISH is not set
CONFIG_RETPOLINE=y
CONFIG_X86_CPU_RESCTRL=y
CONFIG_X86_EXTENDED_PLATFORM=y
# CONFIG_X86_NUMACHIP is not set
# CONFIG_X86_VSMP is not set
CONFIG_X86_UV=y
# CONFIG_X86_GOLDFISH is not set
# CONFIG_X86_INTEL_MID is not set
CONFIG_X86_INTEL_LPSS=y
CONFIG_X86_AMD_PLATFORM_DEVICE=y
CONFIG_IOSF_MBI=y
# CONFIG_IOSF_MBI_DEBUG is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_HYPERVISOR_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_XXL=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_PARAVIRT_SPINLOCKS=y
CONFIG_X86_HV_CALLBACK_VECTOR=y
CONFIG_XEN=y
CONFIG_XEN_PV=y
CONFIG_XEN_PV_SMP=y
# CONFIG_XEN_DOM0 is not set
CONFIG_XEN_PVHVM=y
CONFIG_XEN_PVHVM_SMP=y
CONFIG_XEN_512GB=y
CONFIG_XEN_SAVE_RESTORE=y
# CONFIG_XEN_DEBUG_FS is not set
# CONFIG_XEN_PVH is not set
CONFIG_KVM_GUEST=y
CONFIG_ARCH_CPUIDLE_HALTPOLL=y
# CONFIG_PVH is not set
# CONFIG_KVM_DEBUG_FS is not set
CONFIG_PARAVIRT_TIME_ACCOUNTING=y
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_JAILHOUSE_GUEST is not set
# CONFIG_ACRN_GUEST is not set
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_IA32_FEAT_CTL=y
CONFIG_X86_VMX_FEATURE_NAMES=y
# CONFIG_PROCESSOR_SELECT is not set
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_HYGON=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_ZHAOXIN=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
CONFIG_MAXSMP=y
CONFIG_NR_CPUS_RANGE_BEGIN=8192
CONFIG_NR_CPUS_RANGE_END=8192
CONFIG_NR_CPUS_DEFAULT=8192
CONFIG_NR_CPUS=8192
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
CONFIG_SCHED_MC_PRIO=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
CONFIG_X86_MCELOG_LEGACY=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=m
CONFIG_X86_THERMAL_VECTOR=y

#
# Performance monitoring
#
CONFIG_PERF_EVENTS_INTEL_UNCORE=y
CONFIG_PERF_EVENTS_INTEL_RAPL=y
CONFIG_PERF_EVENTS_INTEL_CSTATE=y
# CONFIG_PERF_EVENTS_AMD_POWER is not set
# end of Performance monitoring

CONFIG_X86_16BIT=y
CONFIG_X86_ESPFIX64=y
CONFIG_X86_VSYSCALL_EMULATION=y
CONFIG_X86_IOPL_IOPERM=y
CONFIG_I8K=m
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_AMD=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_X86_5LEVEL=y
CONFIG_X86_DIRECT_GBPAGES=y
# CONFIG_X86_CPA_STATISTICS is not set
CONFIG_AMD_MEM_ENCRYPT=y
# CONFIG_AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT is not set
CONFIG_NUMA=y
CONFIG_AMD_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
CONFIG_NUMA_EMU=y
CONFIG_NODES_SHIFT=10
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_MEMORY_PROBE=y
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_X86_PMEM_LEGACY_DEVICE=y
CONFIG_X86_PMEM_LEGACY=m
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_ARCH_RANDOM=y
CONFIG_X86_SMAP=y
CONFIG_X86_UMIP=y
CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS=y
CONFIG_X86_INTEL_TSX_MODE_OFF=y
# CONFIG_X86_INTEL_TSX_MODE_ON is not set
# CONFIG_X86_INTEL_TSX_MODE_AUTO is not set
CONFIG_EFI=y
CONFIG_EFI_STUB=y
CONFIG_EFI_MIXED=y
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_KEXEC_FILE=y
CONFIG_ARCH_HAS_KEXEC_PURGATORY=y
# CONFIG_KEXEC_SIG is not set
CONFIG_CRASH_DUMP=y
CONFIG_KEXEC_JUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_RANDOMIZE_BASE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_DYNAMIC_MEMORY_LAYOUT=y
CONFIG_RANDOMIZE_MEMORY=y
CONFIG_RANDOMIZE_MEMORY_PHYSICAL_PADDING=0xa
CONFIG_HOTPLUG_CPU=y
CONFIG_BOOTPARAM_HOTPLUG_CPU0=y
# CONFIG_DEBUG_HOTPLUG_CPU0 is not set
# CONFIG_COMPAT_VDSO is not set
CONFIG_LEGACY_VSYSCALL_EMULATE=y
# CONFIG_LEGACY_VSYSCALL_XONLY is not set
# CONFIG_LEGACY_VSYSCALL_NONE is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_MODIFY_LDT_SYSCALL=y
CONFIG_HAVE_LIVEPATCH=y
CONFIG_LIVEPATCH=y
# end of Processor type and features

CONFIG_ARCH_HAS_ADD_PAGES=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y
CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION=y
CONFIG_ARCH_ENABLE_THP_MIGRATION=y

#
# Power management and ACPI options
#
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
# CONFIG_SUSPEND_SKIP_SYNC is not set
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
# CONFIG_PM_AUTOSLEEP is not set
# CONFIG_PM_WAKELOCKS is not set
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
# CONFIG_PM_TEST_SUSPEND is not set
CONFIG_PM_SLEEP_DEBUG=y
# CONFIG_DPM_WATCHDOG is not set
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
CONFIG_PM_CLK=y
# CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
# CONFIG_ENERGY_MODEL is not set
CONFIG_ARCH_SUPPORTS_ACPI=y
CONFIG_ACPI=y
CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
CONFIG_ACPI_SYSTEM_POWER_STATES_SUPPORT=y
# CONFIG_ACPI_DEBUGGER is not set
CONFIG_ACPI_SPCR_TABLE=y
CONFIG_ACPI_LPIT=y
CONFIG_ACPI_SLEEP=y
# CONFIG_ACPI_PROCFS_POWER is not set
CONFIG_ACPI_REV_OVERRIDE_POSSIBLE=y
CONFIG_ACPI_EC_DEBUGFS=m
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=y
# CONFIG_ACPI_TAD is not set
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_CPU_FREQ_PSS=y
CONFIG_ACPI_PROCESSOR_CSTATE=y
CONFIG_ACPI_PROCESSOR_IDLE=y
CONFIG_ACPI_CPPC_LIB=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_IPMI=m
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=m
CONFIG_ACPI_THERMAL=y
CONFIG_ARCH_HAS_ACPI_TABLE_UPGRADE=y
CONFIG_ACPI_TABLE_UPGRADE=y
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_PCI_SLOT=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_HOTPLUG_MEMORY=y
CONFIG_ACPI_HOTPLUG_IOAPIC=y
CONFIG_ACPI_SBS=m
CONFIG_ACPI_HED=y
CONFIG_ACPI_CUSTOM_METHOD=m
CONFIG_ACPI_BGRT=y
# CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
CONFIG_ACPI_NFIT=m
# CONFIG_NFIT_SECURITY_DEBUG is not set
CONFIG_ACPI_NUMA=y
# CONFIG_ACPI_HMAT is not set
CONFIG_HAVE_ACPI_APEI=y
CONFIG_HAVE_ACPI_APEI_NMI=y
CONFIG_ACPI_APEI=y
CONFIG_ACPI_APEI_GHES=y
CONFIG_ACPI_APEI_PCIEAER=y
CONFIG_ACPI_APEI_MEMORY_FAILURE=y
CONFIG_ACPI_APEI_EINJ=m
CONFIG_ACPI_APEI_ERST_DEBUG=y
# CONFIG_DPTF_POWER is not set
CONFIG_ACPI_WATCHDOG=y
CONFIG_ACPI_EXTLOG=m
CONFIG_ACPI_ADXL=y
# CONFIG_PMIC_OPREGION is not set
# CONFIG_ACPI_CONFIGFS is not set
CONFIG_X86_PM_TIMER=y
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_GOV_ATTR_SET=y
CONFIG_CPU_FREQ_GOV_COMMON=y
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
# CONFIG_CPU_FREQ_GOV_SCHEDUTIL is not set

#
# CPU frequency scaling drivers
#
CONFIG_X86_INTEL_PSTATE=y
CONFIG_X86_PCC_CPUFREQ=m
CONFIG_X86_ACPI_CPUFREQ=m
CONFIG_X86_ACPI_CPUFREQ_CPB=y
CONFIG_X86_POWERNOW_K8=m
CONFIG_X86_AMD_FREQ_SENSITIVITY=m
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_P4_CLOCKMOD=m

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=m
# end of CPU Frequency scaling

#
# CPU Idle
#
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_GOV_LADDER is not set
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_CPU_IDLE_GOV_TEO is not set
# CONFIG_CPU_IDLE_GOV_HALTPOLL is not set
CONFIG_HALTPOLL_CPUIDLE=y
# end of CPU Idle

CONFIG_INTEL_IDLE=y
# end of Power management and ACPI options

#
# Bus options (PCI etc.)
#
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_XEN=y
CONFIG_MMCONF_FAM10H=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_ISA_BUS is not set
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
# CONFIG_X86_SYSFB is not set
# end of Bus options (PCI etc.)

#
# Binary Emulations
#
CONFIG_IA32_EMULATION=y
# CONFIG_X86_X32 is not set
CONFIG_COMPAT_32=y
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
# end of Binary Emulations

#
# Firmware Drivers
#
CONFIG_EDD=m
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_DMIID=y
CONFIG_DMI_SYSFS=y
CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_ISCSI_IBFT=m
CONFIG_FW_CFG_SYSFS=y
# CONFIG_FW_CFG_SYSFS_CMDLINE is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# EFI (Extensible Firmware Interface) Support
#
CONFIG_EFI_VARS=y
CONFIG_EFI_ESRT=y
CONFIG_EFI_VARS_PSTORE=y
CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE=y
CONFIG_EFI_RUNTIME_MAP=y
# CONFIG_EFI_FAKE_MEMMAP is not set
CONFIG_EFI_RUNTIME_WRAPPERS=y
# CONFIG_EFI_BOOTLOADER_CONTROL is not set
# CONFIG_EFI_CAPSULE_LOADER is not set
# CONFIG_EFI_TEST is not set
CONFIG_APPLE_PROPERTIES=y
# CONFIG_RESET_ATTACK_MITIGATION is not set
# CONFIG_EFI_RCI2_TABLE is not set
# CONFIG_EFI_DISABLE_PCI_DMA is not set
# end of EFI (Extensible Firmware Interface) Support

CONFIG_UEFI_CPER=y
CONFIG_UEFI_CPER_X86=y
CONFIG_EFI_DEV_PATH_PARSER=y
CONFIG_EFI_EARLYCON=y

#
# Tegra firmware driver
#
# end of Tegra firmware driver
# end of Firmware Drivers

CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_IRQFD=y
CONFIG_HAVE_KVM_IRQ_ROUTING=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_HAVE_KVM_MSI=y
CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT=y
CONFIG_KVM_VFIO=y
CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT=y
CONFIG_KVM_COMPAT=y
CONFIG_HAVE_KVM_IRQ_BYPASS=y
CONFIG_HAVE_KVM_NO_POLL=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
CONFIG_KVM_INTEL=m
CONFIG_KVM_AMD=m
CONFIG_KVM_AMD_SEV=y
CONFIG_KVM_MMU_AUDIT=y
CONFIG_VHOST_NET=m
# CONFIG_VHOST_SCSI is not set
CONFIG_VHOST_VSOCK=m
CONFIG_VHOST=m
# CONFIG_VHOST_CROSS_ENDIAN_LEGACY is not set

#
# General architecture-dependent options
#
CONFIG_CRASH_CORE=y
CONFIG_KEXEC_CORE=y
CONFIG_HOTPLUG_SMT=y
CONFIG_OPROFILE=m
CONFIG_OPROFILE_EVENT_MULTIPLEX=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
# CONFIG_STATIC_KEYS_SELFTEST is not set
CONFIG_OPTPROBES=y
CONFIG_KPROBES_ON_FTRACE=y
CONFIG_UPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_ARCH_USE_BUILTIN_BSWAP=y
CONFIG_KRETPROBES=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_KPROBES_ON_FTRACE=y
CONFIG_HAVE_FUNCTION_ERROR_INJECTION=y
CONFIG_HAVE_NMI=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_ARCH_HAS_FORTIFY_SOURCE=y
CONFIG_ARCH_HAS_SET_MEMORY=y
CONFIG_ARCH_HAS_SET_DIRECT_MAP=y
CONFIG_HAVE_ARCH_THREAD_STRUCT_WHITELIST=y
CONFIG_ARCH_WANTS_DYNAMIC_TASK_STRUCT=y
CONFIG_HAVE_ASM_MODVERSIONS=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_RSEQ=y
CONFIG_HAVE_FUNCTION_ARG_ACCESS_API=y
CONFIG_HAVE_CLK=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_HARDLOCKUP_DETECTOR_PERF=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_HAVE_ARCH_JUMP_LABEL_RELATIVE=y
CONFIG_MMU_GATHER_TABLE_FREE=y
CONFIG_MMU_GATHER_RCU_TABLE_FREE=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_SECCOMP_FILTER=y
CONFIG_HAVE_ARCH_STACKLEAK=y
CONFIG_HAVE_STACKPROTECTOR=y
CONFIG_CC_HAS_STACKPROTECTOR_NONE=y
CONFIG_STACKPROTECTOR=y
CONFIG_STACKPROTECTOR_STRONG=y
CONFIG_HAVE_ARCH_WITHIN_STACK_FRAMES=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_MOVE_PMD=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD=y
CONFIG_HAVE_ARCH_HUGE_VMAP=y
CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
CONFIG_HAVE_ARCH_SOFT_DIRTY=y
CONFIG_HAVE_MOD_ARCH_SPECIFIC=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=y
CONFIG_ARCH_HAS_ELF_RANDOMIZE=y
CONFIG_HAVE_ARCH_MMAP_RND_BITS=y
CONFIG_HAVE_EXIT_THREAD=y
CONFIG_ARCH_MMAP_RND_BITS=28
CONFIG_HAVE_ARCH_MMAP_RND_COMPAT_BITS=y
CONFIG_ARCH_MMAP_RND_COMPAT_BITS=8
CONFIG_HAVE_ARCH_COMPAT_MMAP_BASES=y
CONFIG_HAVE_COPY_THREAD_TLS=y
CONFIG_HAVE_STACK_VALIDATION=y
CONFIG_HAVE_RELIABLE_STACKTRACE=y
CONFIG_OLD_SIGSUSPEND3=y
CONFIG_COMPAT_OLD_SIGACTION=y
CONFIG_COMPAT_32BIT_TIME=y
CONFIG_HAVE_ARCH_VMAP_STACK=y
CONFIG_VMAP_STACK=y
CONFIG_ARCH_HAS_STRICT_KERNEL_RWX=y
CONFIG_STRICT_KERNEL_RWX=y
CONFIG_ARCH_HAS_STRICT_MODULE_RWX=y
CONFIG_STRICT_MODULE_RWX=y
CONFIG_HAVE_ARCH_PREL32_RELOCATIONS=y
CONFIG_ARCH_USE_MEMREMAP_PROT=y
# CONFIG_LOCK_EVENT_COUNTS is not set
CONFIG_ARCH_HAS_MEM_ENCRYPT=y

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
CONFIG_ARCH_HAS_GCOV_PROFILE_ALL=y
# end of GCOV-based kernel profiling

CONFIG_PLUGIN_HOSTCC="g++"
CONFIG_HAVE_GCC_PLUGINS=y
CONFIG_GCC_PLUGINS=y
# CONFIG_GCC_PLUGIN_CYC_COMPLEXITY is not set
# CONFIG_GCC_PLUGIN_LATENT_ENTROPY is not set
# CONFIG_GCC_PLUGIN_RANDSTRUCT is not set
# end of General architecture-dependent options

CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_MODULE_SIG_FORMAT=y
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
# CONFIG_MODULE_SRCVERSION_ALL is not set
CONFIG_MODULE_SIG=y
# CONFIG_MODULE_SIG_FORCE is not set
CONFIG_MODULE_SIG_ALL=y
# CONFIG_MODULE_SIG_SHA1 is not set
# CONFIG_MODULE_SIG_SHA224 is not set
CONFIG_MODULE_SIG_SHA256=y
# CONFIG_MODULE_SIG_SHA384 is not set
# CONFIG_MODULE_SIG_SHA512 is not set
CONFIG_MODULE_SIG_HASH="sha256"
# CONFIG_MODULE_COMPRESS is not set
# CONFIG_MODULE_ALLOW_MISSING_NAMESPACE_IMPORTS is not set
# CONFIG_UNUSED_SYMBOLS is not set
# CONFIG_TRIM_UNUSED_KSYMS is not set
CONFIG_MODULES_TREE_LOOKUP=y
CONFIG_BLOCK=y
CONFIG_BLK_SCSI_REQUEST=y
CONFIG_BLK_CGROUP_RWSTAT=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLK_DEV_INTEGRITY_T10=m
CONFIG_BLK_DEV_ZONED=y
CONFIG_BLK_DEV_THROTTLING=y
# CONFIG_BLK_DEV_THROTTLING_LOW is not set
# CONFIG_BLK_CMDLINE_PARSER is not set
# CONFIG_BLK_WBT is not set
# CONFIG_BLK_CGROUP_IOLATENCY is not set
# CONFIG_BLK_CGROUP_IOCOST is not set
CONFIG_BLK_DEBUG_FS=y
CONFIG_BLK_DEBUG_FS_ZONED=y
# CONFIG_BLK_SED_OPAL is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_AIX_PARTITION is not set
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
# CONFIG_CMDLINE_PARTITION is not set
# end of Partition Types

CONFIG_BLOCK_COMPAT=y
CONFIG_BLK_MQ_PCI=y
CONFIG_BLK_MQ_VIRTIO=y
CONFIG_BLK_MQ_RDMA=y
CONFIG_BLK_PM=y

#
# IO Schedulers
#
CONFIG_MQ_IOSCHED_DEADLINE=y
CONFIG_MQ_IOSCHED_KYBER=y
# CONFIG_IOSCHED_BFQ is not set
# end of IO Schedulers

CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_PADATA=y
CONFIG_ASN1=y
CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
CONFIG_INLINE_READ_UNLOCK=y
CONFIG_INLINE_READ_UNLOCK_IRQ=y
CONFIG_INLINE_WRITE_UNLOCK=y
CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_RWSEM_SPIN_ON_OWNER=y
CONFIG_LOCK_SPIN_ON_OWNER=y
CONFIG_ARCH_USE_QUEUED_SPINLOCKS=y
CONFIG_QUEUED_SPINLOCKS=y
CONFIG_ARCH_USE_QUEUED_RWLOCKS=y
CONFIG_QUEUED_RWLOCKS=y
CONFIG_ARCH_HAS_SYNC_CORE_BEFORE_USERMODE=y
CONFIG_ARCH_HAS_SYSCALL_WRAPPER=y
CONFIG_FREEZER=y

#
# Executable file formats
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_ELFCORE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_SCRIPT=y
CONFIG_BINFMT_MISC=m
CONFIG_COREDUMP=y
# end of Executable file formats

#
# Memory Management options
#
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_HAVE_FAST_GUP=y
CONFIG_MEMORY_ISOLATION=y
CONFIG_HAVE_BOOTMEM_INFO_NODE=y
CONFIG_MEMORY_HOTPLUG=y
CONFIG_MEMORY_HOTPLUG_SPARSE=y
# CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE is not set
CONFIG_MEMORY_HOTREMOVE=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_MEMORY_BALLOON=y
CONFIG_BALLOON_COMPACTION=y
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_CONTIG_ALLOC=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
CONFIG_HWPOISON_INJECT=m
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
CONFIG_ARCH_WANTS_THP_SWAP=y
CONFIG_THP_SWAP=y
CONFIG_TRANSPARENT_HUGE_PAGECACHE=y
CONFIG_CLEANCACHE=y
CONFIG_FRONTSWAP=y
CONFIG_CMA=y
# CONFIG_CMA_DEBUG is not set
# CONFIG_CMA_DEBUGFS is not set
CONFIG_CMA_AREAS=7
CONFIG_MEM_SOFT_DIRTY=y
CONFIG_ZSWAP=y
CONFIG_ZPOOL=y
CONFIG_ZBUD=y
# CONFIG_Z3FOLD is not set
CONFIG_ZSMALLOC=y
# CONFIG_PGTABLE_MAPPING is not set
# CONFIG_ZSMALLOC_STAT is not set
CONFIG_GENERIC_EARLY_IOREMAP=y
CONFIG_DEFERRED_STRUCT_PAGE_INIT=y
CONFIG_IDLE_PAGE_TRACKING=y
CONFIG_ARCH_HAS_PTE_DEVMAP=y
CONFIG_ZONE_DEVICE=y
CONFIG_DEV_PAGEMAP_OPS=y
# CONFIG_DEVICE_PRIVATE is not set
CONFIG_FRAME_VECTOR=y
CONFIG_ARCH_USES_HIGH_VMA_FLAGS=y
CONFIG_ARCH_HAS_PKEYS=y
# CONFIG_PERCPU_STATS is not set
# CONFIG_GUP_BENCHMARK is not set
# CONFIG_READ_ONLY_THP_FOR_FS is not set
CONFIG_ARCH_HAS_PTE_SPECIAL=y
CONFIG_MAPPING_DIRTY_HELPERS=y
# end of Memory Management options

CONFIG_NET=y
CONFIG_COMPAT_NETLINK_MESSAGES=y
CONFIG_NET_INGRESS=y
CONFIG_NET_EGRESS=y
CONFIG_SKB_EXTENSIONS=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_DIAG=m
CONFIG_UNIX=y
CONFIG_UNIX_SCM=y
CONFIG_UNIX_DIAG=m
# CONFIG_TLS is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
# CONFIG_XFRM_INTERFACE is not set
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
# CONFIG_SMC is not set
# CONFIG_XDP_SOCKETS is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_IP_FIB_TRIE_STATS=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_ROUTE_CLASSID=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
# CONFIG_IP_PNP_BOOTP is not set
# CONFIG_IP_PNP_RARP is not set
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE_DEMUX=m
CONFIG_NET_IP_TUNNEL=m
CONFIG_NET_IPGRE=m
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE_COMMON=y
CONFIG_IP_MROUTE=y
CONFIG_IP_MROUTE_MULTIPLE_TABLES=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
CONFIG_SYN_COOKIES=y
CONFIG_NET_IPVTI=m
CONFIG_NET_UDP_TUNNEL=m
CONFIG_NET_FOU=m
CONFIG_NET_FOU_IP_TUNNELS=y
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
# CONFIG_INET_ESP_OFFLOAD is not set
# CONFIG_INET_ESPINTCP is not set
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
CONFIG_INET_UDP_DIAG=m
# CONFIG_INET_RAW_DIAG is not set
# CONFIG_INET_DIAG_DESTROY is not set
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=m
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=m
CONFIG_TCP_CONG_HTCP=m
CONFIG_TCP_CONG_HSTCP=m
CONFIG_TCP_CONG_HYBLA=m
CONFIG_TCP_CONG_VEGAS=m
# CONFIG_TCP_CONG_NV is not set
CONFIG_TCP_CONG_SCALABLE=m
CONFIG_TCP_CONG_LP=m
CONFIG_TCP_CONG_VENO=m
CONFIG_TCP_CONG_YEAH=m
CONFIG_TCP_CONG_ILLINOIS=m
CONFIG_TCP_CONG_DCTCP=m
# CONFIG_TCP_CONG_CDG is not set
# CONFIG_TCP_CONG_BBR is not set
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
# CONFIG_INET6_ESP_OFFLOAD is not set
CONFIG_INET6_IPCOMP=m
CONFIG_IPV6_MIP6=m
# CONFIG_IPV6_ILA is not set
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_IPV6_VTI=m
CONFIG_IPV6_SIT=m
CONFIG_IPV6_SIT_6RD=y
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=m
CONFIG_IPV6_GRE=m
CONFIG_IPV6_FOU=m
CONFIG_IPV6_FOU_TUNNEL=m
CONFIG_IPV6_MULTIPLE_TABLES=y
# CONFIG_IPV6_SUBTREES is not set
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_MROUTE_MULTIPLE_TABLES=y
CONFIG_IPV6_PIMSM_V2=y
CONFIG_IPV6_SEG6_LWTUNNEL=y
# CONFIG_IPV6_SEG6_HMAC is not set
CONFIG_IPV6_SEG6_BPF=y
CONFIG_NETLABEL=y
CONFIG_MPTCP=y
CONFIG_MPTCP_IPV6=y
# CONFIG_MPTCP_HMAC_TEST is not set
CONFIG_NETWORK_SECMARK=y
CONFIG_NET_PTP_CLASSIFY=y
CONFIG_NETWORK_PHY_TIMESTAMPING=y
CONFIG_NETFILTER=y
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=m

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_INGRESS=y
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_FAMILY_BRIDGE=y
CONFIG_NETFILTER_FAMILY_ARP=y
CONFIG_NETFILTER_NETLINK_ACCT=m
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NETFILTER_NETLINK_OSF=m
CONFIG_NF_CONNTRACK=m
CONFIG_NF_LOG_COMMON=m
# CONFIG_NF_LOG_NETDEV is not set
CONFIG_NETFILTER_CONNCOUNT=m
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_ZONES=y
CONFIG_NF_CONNTRACK_PROCFS=y
CONFIG_NF_CONNTRACK_EVENTS=y
CONFIG_NF_CONNTRACK_TIMEOUT=y
CONFIG_NF_CONNTRACK_TIMESTAMP=y
CONFIG_NF_CONNTRACK_LABELS=y
CONFIG_NF_CT_PROTO_DCCP=y
CONFIG_NF_CT_PROTO_GRE=y
CONFIG_NF_CT_PROTO_SCTP=y
CONFIG_NF_CT_PROTO_UDPLITE=y
CONFIG_NF_CONNTRACK_AMANDA=m
CONFIG_NF_CONNTRACK_FTP=m
CONFIG_NF_CONNTRACK_H323=m
CONFIG_NF_CONNTRACK_IRC=m
CONFIG_NF_CONNTRACK_BROADCAST=m
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
CONFIG_NF_CONNTRACK_SNMP=m
CONFIG_NF_CONNTRACK_PPTP=m
CONFIG_NF_CONNTRACK_SANE=m
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CONNTRACK_TFTP=m
CONFIG_NF_CT_NETLINK=m
CONFIG_NF_CT_NETLINK_TIMEOUT=m
# CONFIG_NETFILTER_NETLINK_GLUE_CT is not set
CONFIG_NF_NAT=m
CONFIG_NF_NAT_AMANDA=m
CONFIG_NF_NAT_FTP=m
CONFIG_NF_NAT_IRC=m
CONFIG_NF_NAT_SIP=m
CONFIG_NF_NAT_TFTP=m
CONFIG_NF_NAT_REDIRECT=y
CONFIG_NF_NAT_MASQUERADE=y
CONFIG_NETFILTER_SYNPROXY=m
CONFIG_NF_TABLES=m
# CONFIG_NF_TABLES_SET is not set
# CONFIG_NF_TABLES_INET is not set
# CONFIG_NF_TABLES_NETDEV is not set
# CONFIG_NFT_NUMGEN is not set
CONFIG_NFT_CT=m
CONFIG_NFT_COUNTER=m
# CONFIG_NFT_CONNLIMIT is not set
CONFIG_NFT_LOG=m
CONFIG_NFT_LIMIT=m
CONFIG_NFT_MASQ=m
CONFIG_NFT_REDIR=m
# CONFIG_NFT_TUNNEL is not set
# CONFIG_NFT_OBJREF is not set
CONFIG_NFT_QUEUE=m
# CONFIG_NFT_QUOTA is not set
CONFIG_NFT_REJECT=m
CONFIG_NFT_COMPAT=m
CONFIG_NFT_HASH=m
# CONFIG_NFT_XFRM is not set
# CONFIG_NFT_SOCKET is not set
# CONFIG_NFT_OSF is not set
# CONFIG_NFT_TPROXY is not set
# CONFIG_NFT_SYNPROXY is not set
# CONFIG_NF_FLOW_TABLE is not set
CONFIG_NETFILTER_XTABLES=y

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=m
CONFIG_NETFILTER_XT_CONNMARK=m
CONFIG_NETFILTER_XT_SET=m

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_AUDIT=m
CONFIG_NETFILTER_XT_TARGET_CHECKSUM=m
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=m
CONFIG_NETFILTER_XT_TARGET_CT=m
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_HL=m
CONFIG_NETFILTER_XT_TARGET_HMARK=m
CONFIG_NETFILTER_XT_TARGET_IDLETIMER=m
CONFIG_NETFILTER_XT_TARGET_LED=m
CONFIG_NETFILTER_XT_TARGET_LOG=m
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_NAT=m
CONFIG_NETFILTER_XT_TARGET_NETMAP=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
CONFIG_NETFILTER_XT_TARGET_REDIRECT=m
CONFIG_NETFILTER_XT_TARGET_MASQUERADE=m
CONFIG_NETFILTER_XT_TARGET_TEE=m
CONFIG_NETFILTER_XT_TARGET_TPROXY=m
CONFIG_NETFILTER_XT_TARGET_TRACE=m
CONFIG_NETFILTER_XT_TARGET_SECMARK=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=m

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=m
CONFIG_NETFILTER_XT_MATCH_BPF=m
CONFIG_NETFILTER_XT_MATCH_CGROUP=m
CONFIG_NETFILTER_XT_MATCH_CLUSTER=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
CONFIG_NETFILTER_XT_MATCH_CONNLABEL=m
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=m
CONFIG_NETFILTER_XT_MATCH_CPU=m
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DEVGROUP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ECN=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_HL=m
# CONFIG_NETFILTER_XT_MATCH_IPCOMP is not set
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
CONFIG_NETFILTER_XT_MATCH_IPVS=m
CONFIG_NETFILTER_XT_MATCH_L2TP=m
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
CONFIG_NETFILTER_XT_MATCH_NFACCT=m
CONFIG_NETFILTER_XT_MATCH_OSF=m
CONFIG_NETFILTER_XT_MATCH_OWNER=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_RECENT=m
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_SOCKET=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_TIME=m
CONFIG_NETFILTER_XT_MATCH_U32=m
# end of Core Netfilter Configuration

CONFIG_IP_SET=m
CONFIG_IP_SET_MAX=256
CONFIG_IP_SET_BITMAP_IP=m
CONFIG_IP_SET_BITMAP_IPMAC=m
CONFIG_IP_SET_BITMAP_PORT=m
CONFIG_IP_SET_HASH_IP=m
CONFIG_IP_SET_HASH_IPMARK=m
CONFIG_IP_SET_HASH_IPPORT=m
CONFIG_IP_SET_HASH_IPPORTIP=m
CONFIG_IP_SET_HASH_IPPORTNET=m
CONFIG_IP_SET_HASH_IPMAC=m
CONFIG_IP_SET_HASH_MAC=m
CONFIG_IP_SET_HASH_NETPORTNET=m
CONFIG_IP_SET_HASH_NET=m
CONFIG_IP_SET_HASH_NETNET=m
CONFIG_IP_SET_HASH_NETPORT=m
CONFIG_IP_SET_HASH_NETIFACE=m
CONFIG_IP_SET_LIST_SET=m
CONFIG_IP_VS=m
CONFIG_IP_VS_IPV6=y
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
CONFIG_IP_VS_PROTO_UDP=y
CONFIG_IP_VS_PROTO_AH_ESP=y
CONFIG_IP_VS_PROTO_ESP=y
CONFIG_IP_VS_PROTO_AH=y
CONFIG_IP_VS_PROTO_SCTP=y

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=m
CONFIG_IP_VS_WRR=m
CONFIG_IP_VS_LC=m
CONFIG_IP_VS_WLC=m
# CONFIG_IP_VS_FO is not set
# CONFIG_IP_VS_OVF is not set
CONFIG_IP_VS_LBLC=m
CONFIG_IP_VS_LBLCR=m
CONFIG_IP_VS_DH=m
CONFIG_IP_VS_SH=m
# CONFIG_IP_VS_MH is not set
CONFIG_IP_VS_SED=m
CONFIG_IP_VS_NQ=m

#
# IPVS SH scheduler
#
CONFIG_IP_VS_SH_TAB_BITS=8

#
# IPVS MH scheduler
#
CONFIG_IP_VS_MH_TAB_INDEX=12

#
# IPVS application helper
#
CONFIG_IP_VS_FTP=m
CONFIG_IP_VS_NFCT=y
CONFIG_IP_VS_PE_SIP=m

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=m
CONFIG_NF_SOCKET_IPV4=m
CONFIG_NF_TPROXY_IPV4=m
# CONFIG_NF_TABLES_IPV4 is not set
# CONFIG_NF_TABLES_ARP is not set
CONFIG_NF_DUP_IPV4=m
# CONFIG_NF_LOG_ARP is not set
CONFIG_NF_LOG_IPV4=m
CONFIG_NF_REJECT_IPV4=m
CONFIG_NF_NAT_SNMP_BASIC=m
CONFIG_NF_NAT_PPTP=m
CONFIG_NF_NAT_H323=m
CONFIG_IP_NF_IPTABLES=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_RPFILTER=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_FILTER=m
CONFIG_IP_NF_TARGET_REJECT=m
CONFIG_IP_NF_TARGET_SYNPROXY=m
CONFIG_IP_NF_NAT=m
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_IP_NF_TARGET_REDIRECT=m
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_CLUSTERIP=m
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_SECURITY=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m
# end of IP: Netfilter Configuration

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_SOCKET_IPV6=m
CONFIG_NF_TPROXY_IPV6=m
# CONFIG_NF_TABLES_IPV6 is not set
CONFIG_NF_DUP_IPV6=m
CONFIG_NF_REJECT_IPV6=m
CONFIG_NF_LOG_IPV6=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_AH=m
CONFIG_IP6_NF_MATCH_EUI64=m
CONFIG_IP6_NF_MATCH_FRAG=m
CONFIG_IP6_NF_MATCH_OPTS=m
CONFIG_IP6_NF_MATCH_HL=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_MATCH_MH=m
CONFIG_IP6_NF_MATCH_RPFILTER=m
CONFIG_IP6_NF_MATCH_RT=m
# CONFIG_IP6_NF_MATCH_SRH is not set
CONFIG_IP6_NF_TARGET_HL=m
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_TARGET_SYNPROXY=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_RAW=m
CONFIG_IP6_NF_SECURITY=m
CONFIG_IP6_NF_NAT=m
CONFIG_IP6_NF_TARGET_MASQUERADE=m
CONFIG_IP6_NF_TARGET_NPT=m
# end of IPv6: Netfilter Configuration

CONFIG_NF_DEFRAG_IPV6=m
# CONFIG_NF_TABLES_BRIDGE is not set
# CONFIG_NF_CONNTRACK_BRIDGE is not set
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
CONFIG_BRIDGE_EBT_AMONG=m
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=m
CONFIG_BRIDGE_EBT_IP6=m
CONFIG_BRIDGE_EBT_LIMIT=m
CONFIG_BRIDGE_EBT_MARK=m
CONFIG_BRIDGE_EBT_PKTTYPE=m
CONFIG_BRIDGE_EBT_STP=m
CONFIG_BRIDGE_EBT_VLAN=m
CONFIG_BRIDGE_EBT_ARPREPLY=m
CONFIG_BRIDGE_EBT_DNAT=m
CONFIG_BRIDGE_EBT_MARK_T=m
CONFIG_BRIDGE_EBT_REDIRECT=m
CONFIG_BRIDGE_EBT_SNAT=m
CONFIG_BRIDGE_EBT_LOG=m
CONFIG_BRIDGE_EBT_NFLOG=m
# CONFIG_BPFILTER is not set
CONFIG_IP_DCCP=m
CONFIG_INET_DCCP_DIAG=m

#
# DCCP CCIDs Configuration
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
CONFIG_IP_DCCP_CCID3=y
# CONFIG_IP_DCCP_CCID3_DEBUG is not set
CONFIG_IP_DCCP_TFRC_LIB=y
# end of DCCP CCIDs Configuration

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
# end of DCCP Kernel Hacking

CONFIG_IP_SCTP=m
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_MD5 is not set
CONFIG_SCTP_DEFAULT_COOKIE_HMAC_SHA1=y
# CONFIG_SCTP_DEFAULT_COOKIE_HMAC_NONE is not set
CONFIG_SCTP_COOKIE_HMAC_MD5=y
CONFIG_SCTP_COOKIE_HMAC_SHA1=y
CONFIG_INET_SCTP_DIAG=m
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
CONFIG_ATM=m
CONFIG_ATM_CLIP=m
# CONFIG_ATM_CLIP_NO_ICMP is not set
CONFIG_ATM_LANE=m
# CONFIG_ATM_MPOA is not set
CONFIG_ATM_BR2684=m
# CONFIG_ATM_BR2684_IPFILTER is not set
CONFIG_L2TP=m
CONFIG_L2TP_DEBUGFS=m
CONFIG_L2TP_V3=y
CONFIG_L2TP_IP=m
CONFIG_L2TP_ETH=m
CONFIG_STP=m
CONFIG_GARP=m
CONFIG_MRP=m
CONFIG_BRIDGE=m
CONFIG_BRIDGE_IGMP_SNOOPING=y
CONFIG_BRIDGE_VLAN_FILTERING=y
CONFIG_HAVE_NET_DSA=y
# CONFIG_NET_DSA is not set
CONFIG_VLAN_8021Q=m
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_VLAN_8021Q_MVRP=y
# CONFIG_DECNET is not set
CONFIG_LLC=m
# CONFIG_LLC2 is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_PHONET is not set
CONFIG_6LOWPAN=m
# CONFIG_6LOWPAN_DEBUGFS is not set
CONFIG_6LOWPAN_NHC=m
CONFIG_6LOWPAN_NHC_DEST=m
CONFIG_6LOWPAN_NHC_FRAGMENT=m
CONFIG_6LOWPAN_NHC_HOP=m
CONFIG_6LOWPAN_NHC_IPV6=m
CONFIG_6LOWPAN_NHC_MOBILITY=m
CONFIG_6LOWPAN_NHC_ROUTING=m
CONFIG_6LOWPAN_NHC_UDP=m
# CONFIG_6LOWPAN_GHC_EXT_HDR_HOP is not set
# CONFIG_6LOWPAN_GHC_UDP is not set
# CONFIG_6LOWPAN_GHC_ICMPV6 is not set
# CONFIG_6LOWPAN_GHC_EXT_HDR_DEST is not set
# CONFIG_6LOWPAN_GHC_EXT_HDR_FRAG is not set
# CONFIG_6LOWPAN_GHC_EXT_HDR_ROUTE is not set
CONFIG_IEEE802154=m
# CONFIG_IEEE802154_NL802154_EXPERIMENTAL is not set
CONFIG_IEEE802154_SOCKET=m
CONFIG_IEEE802154_6LOWPAN=m
CONFIG_MAC802154=m
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_ATM=m
CONFIG_NET_SCH_PRIO=m
CONFIG_NET_SCH_MULTIQ=m
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFB=m
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
# CONFIG_NET_SCH_CBS is not set
# CONFIG_NET_SCH_ETF is not set
# CONFIG_NET_SCH_TAPRIO is not set
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=m
CONFIG_NET_SCH_DRR=m
CONFIG_NET_SCH_MQPRIO=m
# CONFIG_NET_SCH_SKBPRIO is not set
CONFIG_NET_SCH_CHOKE=m
CONFIG_NET_SCH_QFQ=m
CONFIG_NET_SCH_CODEL=m
CONFIG_NET_SCH_FQ_CODEL=m
# CONFIG_NET_SCH_CAKE is not set
CONFIG_NET_SCH_FQ=m
# CONFIG_NET_SCH_HHF is not set
# CONFIG_NET_SCH_PIE is not set
CONFIG_NET_SCH_INGRESS=m
CONFIG_NET_SCH_PLUG=m
# CONFIG_NET_SCH_ETS is not set
# CONFIG_NET_SCH_DEFAULT is not set

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_ROUTE4=m
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=m
CONFIG_NET_CLS_FLOW=m
CONFIG_NET_CLS_CGROUP=y
CONFIG_NET_CLS_BPF=m
CONFIG_NET_CLS_FLOWER=m
CONFIG_NET_CLS_MATCHALL=m
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=m
CONFIG_NET_EMATCH_NBYTE=m
CONFIG_NET_EMATCH_U32=m
CONFIG_NET_EMATCH_META=m
CONFIG_NET_EMATCH_TEXT=m
# CONFIG_NET_EMATCH_CANID is not set
CONFIG_NET_EMATCH_IPSET=m
# CONFIG_NET_EMATCH_IPT is not set
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=m
CONFIG_NET_ACT_SAMPLE=m
CONFIG_NET_ACT_IPT=m
CONFIG_NET_ACT_NAT=m
CONFIG_NET_ACT_PEDIT=m
CONFIG_NET_ACT_SIMP=m
CONFIG_NET_ACT_SKBEDIT=m
CONFIG_NET_ACT_CSUM=m
# CONFIG_NET_ACT_MPLS is not set
CONFIG_NET_ACT_VLAN=m
# CONFIG_NET_ACT_BPF is not set
CONFIG_NET_ACT_CONNMARK=m
# CONFIG_NET_ACT_CTINFO is not set
CONFIG_NET_ACT_SKBMOD=m
# CONFIG_NET_ACT_IFE is not set
CONFIG_NET_ACT_TUNNEL_KEY=m
# CONFIG_NET_ACT_CT is not set
# CONFIG_NET_TC_SKB_EXT is not set
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=m
# CONFIG_BATMAN_ADV is not set
CONFIG_OPENVSWITCH=m
CONFIG_OPENVSWITCH_GRE=m
CONFIG_OPENVSWITCH_VXLAN=m
CONFIG_OPENVSWITCH_GENEVE=m
CONFIG_VSOCKETS=m
CONFIG_VSOCKETS_DIAG=m
CONFIG_VSOCKETS_LOOPBACK=m
CONFIG_VMWARE_VMCI_VSOCKETS=m
CONFIG_VIRTIO_VSOCKETS=m
CONFIG_VIRTIO_VSOCKETS_COMMON=m
CONFIG_HYPERV_VSOCKETS=m
CONFIG_NETLINK_DIAG=m
CONFIG_MPLS=y
CONFIG_NET_MPLS_GSO=y
CONFIG_MPLS_ROUTING=m
CONFIG_MPLS_IPTUNNEL=m
CONFIG_NET_NSH=m
# CONFIG_HSR is not set
CONFIG_NET_SWITCHDEV=y
CONFIG_NET_L3_MASTER_DEV=y
# CONFIG_NET_NCSI is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
# CONFIG_CGROUP_NET_PRIO is not set
CONFIG_CGROUP_NET_CLASSID=y
CONFIG_NET_RX_BUSY_POLL=y
CONFIG_BQL=y
CONFIG_BPF_JIT=y
CONFIG_BPF_STREAM_PARSER=y
CONFIG_NET_FLOW_LIMIT=y

#
# Network testing
#
CONFIG_NET_PKTGEN=m
CONFIG_NET_DROP_MONITOR=y
# end of Network testing
# end of Networking options

# CONFIG_HAMRADIO is not set
CONFIG_CAN=m
CONFIG_CAN_RAW=m
CONFIG_CAN_BCM=m
CONFIG_CAN_GW=m
# CONFIG_CAN_J1939 is not set

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=m
# CONFIG_CAN_VXCAN is not set
CONFIG_CAN_SLCAN=m
CONFIG_CAN_DEV=m
CONFIG_CAN_CALC_BITTIMING=y
# CONFIG_CAN_KVASER_PCIEFD is not set
CONFIG_CAN_C_CAN=m
CONFIG_CAN_C_CAN_PLATFORM=m
CONFIG_CAN_C_CAN_PCI=m
CONFIG_CAN_CC770=m
# CONFIG_CAN_CC770_ISA is not set
CONFIG_CAN_CC770_PLATFORM=m
# CONFIG_CAN_IFI_CANFD is not set
# CONFIG_CAN_M_CAN is not set
# CONFIG_CAN_PEAK_PCIEFD is not set
CONFIG_CAN_SJA1000=m
CONFIG_CAN_EMS_PCI=m
# CONFIG_CAN_F81601 is not set
CONFIG_CAN_KVASER_PCI=m
CONFIG_CAN_PEAK_PCI=m
CONFIG_CAN_PEAK_PCIEC=y
CONFIG_CAN_PLX_PCI=m
# CONFIG_CAN_SJA1000_ISA is not set
CONFIG_CAN_SJA1000_PLATFORM=m
CONFIG_CAN_SOFTING=m

#
# CAN SPI interfaces
#
# CONFIG_CAN_HI311X is not set
# CONFIG_CAN_MCP251X is not set
# end of CAN SPI interfaces

#
# CAN USB interfaces
#
CONFIG_CAN_8DEV_USB=m
CONFIG_CAN_EMS_USB=m
CONFIG_CAN_ESD_USB2=m
# CONFIG_CAN_GS_USB is not set
CONFIG_CAN_KVASER_USB=m
# CONFIG_CAN_MCBA_USB is not set
CONFIG_CAN_PEAK_USB=m
# CONFIG_CAN_UCAN is not set
# end of CAN USB interfaces

# CONFIG_CAN_DEBUG_DEVICES is not set
# end of CAN Device Drivers

CONFIG_BT=m
CONFIG_BT_BREDR=y
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_CMTP=m
CONFIG_BT_HIDP=m
CONFIG_BT_HS=y
CONFIG_BT_LE=y
# CONFIG_BT_6LOWPAN is not set
# CONFIG_BT_LEDS is not set
# CONFIG_BT_SELFTEST is not set
CONFIG_BT_DEBUGFS=y

#
# Bluetooth device drivers
#
CONFIG_BT_INTEL=m
CONFIG_BT_BCM=m
CONFIG_BT_RTL=m
CONFIG_BT_HCIBTUSB=m
# CONFIG_BT_HCIBTUSB_AUTOSUSPEND is not set
CONFIG_BT_HCIBTUSB_BCM=y
# CONFIG_BT_HCIBTUSB_MTK is not set
CONFIG_BT_HCIBTUSB_RTL=y
CONFIG_BT_HCIBTSDIO=m
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
CONFIG_BT_HCIUART_ATH3K=y
# CONFIG_BT_HCIUART_INTEL is not set
# CONFIG_BT_HCIUART_AG6XX is not set
CONFIG_BT_HCIBCM203X=m
CONFIG_BT_HCIBPA10X=m
CONFIG_BT_HCIBFUSB=m
CONFIG_BT_HCIVHCI=m
CONFIG_BT_MRVL=m
CONFIG_BT_MRVL_SDIO=m
CONFIG_BT_ATH3K=m
# CONFIG_BT_MTKSDIO is not set
# end of Bluetooth device drivers

# CONFIG_AF_RXRPC is not set
# CONFIG_AF_KCM is not set
CONFIG_STREAM_PARSER=y
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_WEXT_PRIV=y
CONFIG_CFG80211=m
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
# CONFIG_CFG80211_CERTIFICATION_ONUS is not set
CONFIG_CFG80211_REQUIRE_SIGNED_REGDB=y
CONFIG_CFG80211_USE_KERNEL_REGDB_KEYS=y
CONFIG_CFG80211_DEFAULT_PS=y
# CONFIG_CFG80211_DEBUGFS is not set
CONFIG_CFG80211_CRDA_SUPPORT=y
CONFIG_CFG80211_WEXT=y
CONFIG_LIB80211=m
# CONFIG_LIB80211_DEBUG is not set
CONFIG_MAC80211=m
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUGFS=y
# CONFIG_MAC80211_MESSAGE_TRACING is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
CONFIG_MAC80211_STA_HASH_MAX_SIZE=0
# CONFIG_WIMAX is not set
CONFIG_RFKILL=m
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
# CONFIG_RFKILL_GPIO is not set
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
# CONFIG_NET_9P_XEN is not set
# CONFIG_NET_9P_RDMA is not set
# CONFIG_NET_9P_DEBUG is not set
# CONFIG_CAIF is not set
CONFIG_CEPH_LIB=m
# CONFIG_CEPH_LIB_PRETTYDEBUG is not set
CONFIG_CEPH_LIB_USE_DNS_RESOLVER=y
# CONFIG_NFC is not set
CONFIG_PSAMPLE=m
# CONFIG_NET_IFE is not set
CONFIG_LWTUNNEL=y
CONFIG_LWTUNNEL_BPF=y
CONFIG_DST_CACHE=y
CONFIG_GRO_CELLS=y
CONFIG_NET_SOCK_MSG=y
CONFIG_NET_DEVLINK=y
CONFIG_PAGE_POOL=y
CONFIG_FAILOVER=m
CONFIG_ETHTOOL_NETLINK=y
CONFIG_HAVE_EBPF_JIT=y

#
# Device Drivers
#
CONFIG_HAVE_EISA=y
# CONFIG_EISA is not set
CONFIG_HAVE_PCI=y
CONFIG_PCI=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
CONFIG_PCIEAER=y
CONFIG_PCIEAER_INJECT=m
CONFIG_PCIE_ECRC=y
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_POWER_SUPERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_PCIE_PME=y
# CONFIG_PCIE_DPC is not set
# CONFIG_PCIE_PTM is not set
# CONFIG_PCIE_BW is not set
CONFIG_PCI_MSI=y
CONFIG_PCI_MSI_IRQ_DOMAIN=y
CONFIG_PCI_QUIRKS=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
CONFIG_PCI_STUB=y
# CONFIG_PCI_PF_STUB is not set
# CONFIG_XEN_PCIDEV_FRONTEND is not set
CONFIG_PCI_ATS=y
CONFIG_PCI_LOCKLESS_CONFIG=y
CONFIG_PCI_IOV=y
CONFIG_PCI_PRI=y
CONFIG_PCI_PASID=y
# CONFIG_PCI_P2PDMA is not set
CONFIG_PCI_LABEL=y
CONFIG_PCI_HYPERV=m
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_ACPI=y
CONFIG_HOTPLUG_PCI_ACPI_IBM=m
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=y

#
# PCI controller drivers
#
CONFIG_VMD=y
CONFIG_PCI_HYPERV_INTERFACE=m

#
# DesignWare PCI Core Support
#
# CONFIG_PCIE_DW_PLAT_HOST is not set
# CONFIG_PCI_MESON is not set
# end of DesignWare PCI Core Support

#
# Cadence PCIe controllers support
#
# end of Cadence PCIe controllers support
# end of PCI controller drivers

#
# PCI Endpoint
#
# CONFIG_PCI_ENDPOINT is not set
# end of PCI Endpoint

#
# PCI switch controller drivers
#
# CONFIG_PCI_SW_SWITCHTEC is not set
# end of PCI switch controller drivers

CONFIG_PCCARD=y
# CONFIG_PCMCIA is not set
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=m
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
# CONFIG_RAPIDIO is not set

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER=y
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y

#
# Firmware loader
#
CONFIG_FW_LOADER=y
CONFIG_FW_LOADER_PAGED_BUF=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_FW_LOADER_USER_HELPER=y
# CONFIG_FW_LOADER_USER_HELPER_FALLBACK is not set
# CONFIG_FW_LOADER_COMPRESS is not set
CONFIG_FW_CACHE=y
# end of Firmware loader

CONFIG_WANT_DEV_COREDUMP=y
CONFIG_ALLOW_DEV_COREDUMP=y
CONFIG_DEV_COREDUMP=y
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_DEBUG_TEST_DRIVER_REMOVE is not set
# CONFIG_TEST_ASYNC_DRIVER_PROBE is not set
CONFIG_SYS_HYPERVISOR=y
CONFIG_GENERIC_CPU_AUTOPROBE=y
CONFIG_GENERIC_CPU_VULNERABILITIES=y
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=m
CONFIG_REGMAP_SPI=m
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
# CONFIG_DMA_FENCE_TRACE is not set
# end of Generic Driver Options

#
# Bus devices
#
# end of Bus devices

CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
# CONFIG_GNSS is not set
CONFIG_MTD=m
# CONFIG_MTD_TESTS is not set

#
# Partition parsers
#
# CONFIG_MTD_AR7_PARTS is not set
# CONFIG_MTD_CMDLINE_PARTS is not set
# CONFIG_MTD_REDBOOT_PARTS is not set
# end of Partition parsers

#
# User Modules And Translation Layers
#
CONFIG_MTD_BLKDEVS=m
CONFIG_MTD_BLOCK=m
# CONFIG_MTD_BLOCK_RO is not set
# CONFIG_FTL is not set
# CONFIG_NFTL is not set
# CONFIG_INFTL is not set
# CONFIG_RFD_FTL is not set
# CONFIG_SSFDC is not set
# CONFIG_SM_FTL is not set
# CONFIG_MTD_OOPS is not set
# CONFIG_MTD_SWAP is not set
# CONFIG_MTD_PARTITIONED_MASTER is not set

#
# RAM/ROM/Flash chip drivers
#
# CONFIG_MTD_CFI is not set
# CONFIG_MTD_JEDECPROBE is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_RAM is not set
# CONFIG_MTD_ROM is not set
# CONFIG_MTD_ABSENT is not set
# end of RAM/ROM/Flash chip drivers

#
# Mapping drivers for chip access
#
# CONFIG_MTD_COMPLEX_MAPPINGS is not set
# CONFIG_MTD_INTEL_VR_NOR is not set
# CONFIG_MTD_PLATRAM is not set
# end of Mapping drivers for chip access

#
# Self-contained MTD device drivers
#
# CONFIG_MTD_PMC551 is not set
# CONFIG_MTD_DATAFLASH is not set
# CONFIG_MTD_MCHP23K256 is not set
# CONFIG_MTD_SST25L is not set
# CONFIG_MTD_SLRAM is not set
# CONFIG_MTD_PHRAM is not set
# CONFIG_MTD_MTDRAM is not set
# CONFIG_MTD_BLOCK2MTD is not set

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOCG3 is not set
# end of Self-contained MTD device drivers

# CONFIG_MTD_ONENAND is not set
# CONFIG_MTD_RAW_NAND is not set
# CONFIG_MTD_SPI_NAND is not set

#
# LPDDR & LPDDR2 PCM memory drivers
#
# CONFIG_MTD_LPDDR is not set
# end of LPDDR & LPDDR2 PCM memory drivers

# CONFIG_MTD_SPI_NOR is not set
CONFIG_MTD_UBI=m
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_LIMIT=20
# CONFIG_MTD_UBI_FASTMAP is not set
# CONFIG_MTD_UBI_GLUEBI is not set
# CONFIG_MTD_UBI_BLOCK is not set
# CONFIG_MTD_HYPERBUS is not set
# CONFIG_OF is not set
CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
CONFIG_PARPORT_SERIAL=m
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG_MESSAGES is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_NULL_BLK=m
CONFIG_BLK_DEV_NULL_BLK_FAULT_INJECTION=y
CONFIG_BLK_DEV_FD=m
CONFIG_CDROM=m
# CONFIG_PARIDE is not set
CONFIG_BLK_DEV_PCIESSD_MTIP32XX=m
# CONFIG_ZRAM is not set
# CONFIG_BLK_DEV_UMEM is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_LOOP_MIN_COUNT=0
# CONFIG_BLK_DEV_CRYPTOLOOP is not set
# CONFIG_BLK_DEV_DRBD is not set
CONFIG_BLK_DEV_NBD=m
# CONFIG_BLK_DEV_SKD is not set
CONFIG_BLK_DEV_SX8=m
CONFIG_BLK_DEV_RAM=m
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=16384
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
CONFIG_ATA_OVER_ETH=m
CONFIG_XEN_BLKDEV_FRONTEND=m
CONFIG_VIRTIO_BLK=y
CONFIG_BLK_DEV_RBD=m
# CONFIG_BLK_DEV_RSXX is not set

#
# NVME Support
#
CONFIG_NVME_CORE=m
CONFIG_BLK_DEV_NVME=m
CONFIG_NVME_MULTIPATH=y
# CONFIG_NVME_HWMON is not set
CONFIG_NVME_FABRICS=m
# CONFIG_NVME_RDMA is not set
CONFIG_NVME_FC=m
# CONFIG_NVME_TCP is not set
CONFIG_NVME_TARGET=m
CONFIG_NVME_TARGET_LOOP=m
# CONFIG_NVME_TARGET_RDMA is not set
CONFIG_NVME_TARGET_FC=m
CONFIG_NVME_TARGET_FCLOOP=m
# CONFIG_NVME_TARGET_TCP is not set
# end of NVME Support

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=m
# CONFIG_AD525X_DPOT is not set
# CONFIG_DUMMY_IRQ is not set
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
CONFIG_TIFM_CORE=m
CONFIG_TIFM_7XX1=m
# CONFIG_ICS932S401 is not set
CONFIG_ENCLOSURE_SERVICES=m
CONFIG_SGI_XP=m
CONFIG_HP_ILO=m
CONFIG_SGI_GRU=m
# CONFIG_SGI_GRU_DEBUG is not set
CONFIG_APDS9802ALS=m
CONFIG_ISL29003=m
CONFIG_ISL29020=m
CONFIG_SENSORS_TSL2550=m
CONFIG_SENSORS_BH1770=m
CONFIG_SENSORS_APDS990X=m
# CONFIG_HMC6352 is not set
# CONFIG_DS1682 is not set
CONFIG_VMWARE_BALLOON=m
# CONFIG_LATTICE_ECP3_CONFIG is not set
# CONFIG_SRAM is not set
# CONFIG_PCI_ENDPOINT_TEST is not set
# CONFIG_XILINX_SDFEC is not set
CONFIG_PVPANIC=y
# CONFIG_C2PORT is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=m
# CONFIG_EEPROM_AT25 is not set
CONFIG_EEPROM_LEGACY=m
CONFIG_EEPROM_MAX6875=m
CONFIG_EEPROM_93CX6=m
# CONFIG_EEPROM_93XX46 is not set
# CONFIG_EEPROM_IDT_89HPESX is not set
# CONFIG_EEPROM_EE1004 is not set
# end of EEPROM support

CONFIG_CB710_CORE=m
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
# end of Texas Instruments shared transport line discipline

CONFIG_SENSORS_LIS3_I2C=m
CONFIG_ALTERA_STAPL=m
CONFIG_INTEL_MEI=m
CONFIG_INTEL_MEI_ME=m
# CONFIG_INTEL_MEI_TXE is not set
# CONFIG_INTEL_MEI_HDCP is not set
CONFIG_VMWARE_VMCI=m

#
# Intel MIC & related support
#
# CONFIG_INTEL_MIC_BUS is not set
# CONFIG_SCIF_BUS is not set
# CONFIG_VOP_BUS is not set
# end of Intel MIC & related support

# CONFIG_GENWQE is not set
# CONFIG_ECHO is not set
# CONFIG_MISC_ALCOR_PCI is not set
# CONFIG_MISC_RTSX_PCI is not set
# CONFIG_MISC_RTSX_USB is not set
# CONFIG_HABANA_AI is not set
# end of Misc devices

CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
CONFIG_CHR_DEV_ST=m
CONFIG_BLK_DEV_SR=m
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=m
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_ENCLOSURE=m
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
CONFIG_SCSI_SRP_ATTRS=m
# end of SCSI Transports

CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=m
CONFIG_ISCSI_BOOT_SYSFS=m
CONFIG_SCSI_CXGB3_ISCSI=m
CONFIG_SCSI_CXGB4_ISCSI=m
CONFIG_SCSI_BNX2_ISCSI=m
CONFIG_SCSI_BNX2X_FCOE=m
CONFIG_BE2ISCSI=m
# CONFIG_BLK_DEV_3W_XXXX_RAID is not set
CONFIG_SCSI_HPSA=m
CONFIG_SCSI_3W_9XXX=m
CONFIG_SCSI_3W_SAS=m
# CONFIG_SCSI_ACARD is not set
CONFIG_SCSI_AACRAID=m
# CONFIG_SCSI_AIC7XXX is not set
CONFIG_SCSI_AIC79XX=m
CONFIG_AIC79XX_CMDS_PER_DEVICE=4
CONFIG_AIC79XX_RESET_DELAY_MS=15000
# CONFIG_AIC79XX_DEBUG_ENABLE is not set
CONFIG_AIC79XX_DEBUG_MASK=0
# CONFIG_AIC79XX_REG_PRETTY_PRINT is not set
# CONFIG_SCSI_AIC94XX is not set
CONFIG_SCSI_MVSAS=m
# CONFIG_SCSI_MVSAS_DEBUG is not set
CONFIG_SCSI_MVSAS_TASKLET=y
CONFIG_SCSI_MVUMI=m
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
CONFIG_SCSI_ARCMSR=m
# CONFIG_SCSI_ESAS2R is not set
# CONFIG_MEGARAID_NEWGEN is not set
# CONFIG_MEGARAID_LEGACY is not set
CONFIG_MEGARAID_SAS=m
CONFIG_SCSI_MPT3SAS=m
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
CONFIG_SCSI_MPT3SAS_MAX_SGE=128
CONFIG_SCSI_MPT2SAS=m
# CONFIG_SCSI_SMARTPQI is not set
CONFIG_SCSI_UFSHCD=m
CONFIG_SCSI_UFSHCD_PCI=m
# CONFIG_SCSI_UFS_DWC_TC_PCI is not set
# CONFIG_SCSI_UFSHCD_PLATFORM is not set
# CONFIG_SCSI_UFS_BSG is not set
CONFIG_SCSI_HPTIOP=m
# CONFIG_SCSI_BUSLOGIC is not set
# CONFIG_SCSI_MYRB is not set
# CONFIG_SCSI_MYRS is not set
CONFIG_VMWARE_PVSCSI=m
# CONFIG_XEN_SCSI_FRONTEND is not set
CONFIG_HYPERV_STORAGE=m
CONFIG_LIBFC=m
CONFIG_LIBFCOE=m
CONFIG_FCOE=m
CONFIG_FCOE_FNIC=m
# CONFIG_SCSI_SNIC is not set
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_FDOMAIN_PCI is not set
# CONFIG_SCSI_GDTH is not set
CONFIG_SCSI_ISCI=m
# CONFIG_SCSI_IPS is not set
CONFIG_SCSI_INITIO=m
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_PPA is not set
# CONFIG_SCSI_IMM is not set
CONFIG_SCSI_STEX=m
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
CONFIG_SCSI_QLA_FC=m
CONFIG_TCM_QLA2XXX=m
# CONFIG_TCM_QLA2XXX_DEBUG is not set
CONFIG_SCSI_QLA_ISCSI=m
# CONFIG_QEDI is not set
# CONFIG_QEDF is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
# CONFIG_SCSI_AM53C974 is not set
# CONFIG_SCSI_WD719X is not set
CONFIG_SCSI_DEBUG=m
CONFIG_SCSI_PMCRAID=m
CONFIG_SCSI_PM8001=m
# CONFIG_SCSI_BFA_FC is not set
CONFIG_SCSI_VIRTIO=m
# CONFIG_SCSI_CHELSIO_FCOE is not set
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=y
CONFIG_SCSI_DH_HP_SW=y
CONFIG_SCSI_DH_EMC=y
CONFIG_SCSI_DH_ALUA=y
# end of SCSI device support

CONFIG_ATA=m
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
# CONFIG_SATA_ZPODD is not set
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=m
CONFIG_SATA_MOBILE_LPM_POLICY=0
CONFIG_SATA_AHCI_PLATFORM=m
# CONFIG_SATA_INIC162X is not set
CONFIG_SATA_ACARD_AHCI=m
CONFIG_SATA_SIL24=m
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
CONFIG_PDC_ADMA=m
CONFIG_SATA_QSTOR=m
CONFIG_SATA_SX4=m
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=m
# CONFIG_SATA_DWC is not set
CONFIG_SATA_MV=m
CONFIG_SATA_NV=m
CONFIG_SATA_PROMISE=m
CONFIG_SATA_SIL=m
CONFIG_SATA_SIS=m
CONFIG_SATA_SVW=m
CONFIG_SATA_ULI=m
CONFIG_SATA_VIA=m
CONFIG_SATA_VITESSE=m

#
# PATA SFF controllers with BMDMA
#
CONFIG_PATA_ALI=m
CONFIG_PATA_AMD=m
CONFIG_PATA_ARTOP=m
CONFIG_PATA_ATIIXP=m
CONFIG_PATA_ATP867X=m
CONFIG_PATA_CMD64X=m
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
CONFIG_PATA_HPT366=m
CONFIG_PATA_HPT37X=m
CONFIG_PATA_HPT3X2N=m
CONFIG_PATA_HPT3X3=m
# CONFIG_PATA_HPT3X3_DMA is not set
CONFIG_PATA_IT8213=m
CONFIG_PATA_IT821X=m
CONFIG_PATA_JMICRON=m
CONFIG_PATA_MARVELL=m
CONFIG_PATA_NETCELL=m
CONFIG_PATA_NINJA32=m
# CONFIG_PATA_NS87415 is not set
CONFIG_PATA_OLDPIIX=m
# CONFIG_PATA_OPTIDMA is not set
CONFIG_PATA_PDC2027X=m
CONFIG_PATA_PDC_OLD=m
# CONFIG_PATA_RADISYS is not set
CONFIG_PATA_RDC=m
CONFIG_PATA_SCH=m
CONFIG_PATA_SERVERWORKS=m
CONFIG_PATA_SIL680=m
CONFIG_PATA_SIS=m
CONFIG_PATA_TOSHIBA=m
# CONFIG_PATA_TRIFLEX is not set
CONFIG_PATA_VIA=m
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_PLATFORM is not set
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
CONFIG_PATA_ACPI=m
CONFIG_ATA_GENERIC=m
# CONFIG_PATA_LEGACY is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
CONFIG_MD_MULTIPATH=m
CONFIG_MD_FAULTY=m
# CONFIG_MD_CLUSTER is not set
# CONFIG_BCACHE is not set
CONFIG_BLK_DEV_DM_BUILTIN=y
CONFIG_BLK_DEV_DM=m
CONFIG_DM_DEBUG=y
CONFIG_DM_BUFIO=m
# CONFIG_DM_DEBUG_BLOCK_MANAGER_LOCKING is not set
CONFIG_DM_BIO_PRISON=m
CONFIG_DM_PERSISTENT_DATA=m
# CONFIG_DM_UNSTRIPED is not set
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=m
CONFIG_DM_THIN_PROVISIONING=m
CONFIG_DM_CACHE=m
CONFIG_DM_CACHE_SMQ=m
# CONFIG_DM_WRITECACHE is not set
CONFIG_DM_ERA=m
# CONFIG_DM_CLONE is not set
CONFIG_DM_MIRROR=m
CONFIG_DM_LOG_USERSPACE=m
CONFIG_DM_RAID=m
CONFIG_DM_ZERO=m
CONFIG_DM_MULTIPATH=m
CONFIG_DM_MULTIPATH_QL=m
CONFIG_DM_MULTIPATH_ST=m
CONFIG_DM_DELAY=m
# CONFIG_DM_DUST is not set
CONFIG_DM_UEVENT=y
CONFIG_DM_FLAKEY=m
CONFIG_DM_VERITY=m
# CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG is not set
# CONFIG_DM_VERITY_FEC is not set
CONFIG_DM_SWITCH=m
CONFIG_DM_LOG_WRITES=m
# CONFIG_DM_INTEGRITY is not set
# CONFIG_DM_ZONED is not set
CONFIG_TARGET_CORE=m
CONFIG_TCM_IBLOCK=m
CONFIG_TCM_FILEIO=m
CONFIG_TCM_PSCSI=m
CONFIG_TCM_USER2=m
CONFIG_LOOPBACK_TARGET=m
CONFIG_TCM_FC=m
CONFIG_ISCSI_TARGET=m
CONFIG_ISCSI_TARGET_CXGB4=m
# CONFIG_SBP_TARGET is not set
CONFIG_FUSION=y
CONFIG_FUSION_SPI=m
# CONFIG_FUSION_FC is not set
CONFIG_FUSION_SAS=m
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=m
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_SBP2=m
CONFIG_FIREWIRE_NET=m
# CONFIG_FIREWIRE_NOSY is not set
# end of IEEE 1394 (FireWire) support

CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
CONFIG_MII=y
CONFIG_NET_CORE=y
CONFIG_BONDING=m
CONFIG_DUMMY=m
# CONFIG_WIREGUARD is not set
# CONFIG_EQUALIZER is not set
CONFIG_NET_FC=y
CONFIG_IFB=m
CONFIG_NET_TEAM=m
CONFIG_NET_TEAM_MODE_BROADCAST=m
CONFIG_NET_TEAM_MODE_ROUNDROBIN=m
CONFIG_NET_TEAM_MODE_RANDOM=m
CONFIG_NET_TEAM_MODE_ACTIVEBACKUP=m
CONFIG_NET_TEAM_MODE_LOADBALANCE=m
CONFIG_MACVLAN=m
CONFIG_MACVTAP=m
# CONFIG_IPVLAN is not set
CONFIG_VXLAN=m
CONFIG_GENEVE=m
# CONFIG_GTP is not set
CONFIG_MACSEC=y
CONFIG_NETCONSOLE=m
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_NTB_NETDEV=m
CONFIG_TUN=m
CONFIG_TAP=m
# CONFIG_TUN_VNET_CROSS_LE is not set
CONFIG_VETH=m
CONFIG_VIRTIO_NET=m
CONFIG_NLMON=m
CONFIG_NET_VRF=y
CONFIG_VSOCKMON=m
# CONFIG_ARCNET is not set
# CONFIG_ATM_DRIVERS is not set

#
# Distributed Switch Architecture drivers
#
# end of Distributed Switch Architecture drivers

CONFIG_ETHERNET=y
CONFIG_MDIO=y
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_NET_VENDOR_ADAPTEC is not set
CONFIG_NET_VENDOR_AGERE=y
# CONFIG_ET131X is not set
CONFIG_NET_VENDOR_ALACRITECH=y
# CONFIG_SLICOSS is not set
# CONFIG_NET_VENDOR_ALTEON is not set
# CONFIG_ALTERA_TSE is not set
CONFIG_NET_VENDOR_AMAZON=y
CONFIG_ENA_ETHERNET=m
CONFIG_NET_VENDOR_AMD=y
CONFIG_AMD8111_ETH=m
CONFIG_PCNET32=m
CONFIG_AMD_XGBE=m
# CONFIG_AMD_XGBE_DCB is not set
CONFIG_AMD_XGBE_HAVE_ECC=y
CONFIG_NET_VENDOR_AQUANTIA=y
CONFIG_AQTION=m
CONFIG_NET_VENDOR_ARC=y
CONFIG_NET_VENDOR_ATHEROS=y
CONFIG_ATL2=m
CONFIG_ATL1=m
CONFIG_ATL1E=m
CONFIG_ATL1C=m
CONFIG_ALX=m
CONFIG_NET_VENDOR_AURORA=y
# CONFIG_AURORA_NB8800 is not set
CONFIG_NET_VENDOR_BROADCOM=y
CONFIG_B44=m
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
# CONFIG_BCMGENET is not set
CONFIG_BNX2=m
CONFIG_CNIC=m
CONFIG_TIGON3=y
CONFIG_TIGON3_HWMON=y
CONFIG_BNX2X=m
CONFIG_BNX2X_SRIOV=y
# CONFIG_SYSTEMPORT is not set
CONFIG_BNXT=m
CONFIG_BNXT_SRIOV=y
CONFIG_BNXT_FLOWER_OFFLOAD=y
CONFIG_BNXT_DCB=y
CONFIG_BNXT_HWMON=y
CONFIG_NET_VENDOR_BROCADE=y
CONFIG_BNA=m
CONFIG_NET_VENDOR_CADENCE=y
CONFIG_MACB=m
CONFIG_MACB_USE_HWSTAMP=y
# CONFIG_MACB_PCI is not set
CONFIG_NET_VENDOR_CAVIUM=y
# CONFIG_THUNDER_NIC_PF is not set
# CONFIG_THUNDER_NIC_VF is not set
# CONFIG_THUNDER_NIC_BGX is not set
# CONFIG_THUNDER_NIC_RGX is not set
CONFIG_CAVIUM_PTP=y
CONFIG_LIQUIDIO=m
CONFIG_LIQUIDIO_VF=m
CONFIG_NET_VENDOR_CHELSIO=y
# CONFIG_CHELSIO_T1 is not set
CONFIG_CHELSIO_T3=m
CONFIG_CHELSIO_T4=m
# CONFIG_CHELSIO_T4_DCB is not set
CONFIG_CHELSIO_T4VF=m
CONFIG_CHELSIO_LIB=m
CONFIG_NET_VENDOR_CISCO=y
CONFIG_ENIC=m
CONFIG_NET_VENDOR_CORTINA=y
# CONFIG_CX_ECAT is not set
CONFIG_DNET=m
CONFIG_NET_VENDOR_DEC=y
CONFIG_NET_TULIP=y
CONFIG_DE2104X=m
CONFIG_DE2104X_DSL=0
CONFIG_TULIP=y
# CONFIG_TULIP_MWI is not set
CONFIG_TULIP_MMIO=y
# CONFIG_TULIP_NAPI is not set
CONFIG_DE4X5=m
CONFIG_WINBOND_840=m
CONFIG_DM9102=m
CONFIG_ULI526X=m
CONFIG_PCMCIA_XIRCOM=m
# CONFIG_NET_VENDOR_DLINK is not set
CONFIG_NET_VENDOR_EMULEX=y
CONFIG_BE2NET=m
CONFIG_BE2NET_HWMON=y
CONFIG_BE2NET_BE2=y
CONFIG_BE2NET_BE3=y
CONFIG_BE2NET_LANCER=y
CONFIG_BE2NET_SKYHAWK=y
CONFIG_NET_VENDOR_EZCHIP=y
CONFIG_NET_VENDOR_GOOGLE=y
# CONFIG_GVE is not set
CONFIG_NET_VENDOR_HUAWEI=y
# CONFIG_HINIC is not set
# CONFIG_NET_VENDOR_I825XX is not set
CONFIG_NET_VENDOR_INTEL=y
# CONFIG_E100 is not set
CONFIG_E1000=y
CONFIG_E1000E=y
CONFIG_E1000E_HWTS=y
CONFIG_IGB=y
CONFIG_IGB_HWMON=y
CONFIG_IGBVF=m
# CONFIG_IXGB is not set
CONFIG_IXGBE=y
CONFIG_IXGBE_HWMON=y
CONFIG_IXGBE_DCB=y
CONFIG_IXGBEVF=m
CONFIG_I40E=y
CONFIG_I40E_DCB=y
CONFIG_IAVF=m
CONFIG_I40EVF=m
# CONFIG_ICE is not set
CONFIG_FM10K=m
# CONFIG_IGC is not set
CONFIG_JME=m
CONFIG_NET_VENDOR_MARVELL=y
CONFIG_MVMDIO=m
CONFIG_SKGE=y
# CONFIG_SKGE_DEBUG is not set
CONFIG_SKGE_GENESIS=y
CONFIG_SKY2=m
# CONFIG_SKY2_DEBUG is not set
CONFIG_NET_VENDOR_MELLANOX=y
CONFIG_MLX4_EN=m
CONFIG_MLX4_EN_DCB=y
CONFIG_MLX4_CORE=m
CONFIG_MLX4_DEBUG=y
CONFIG_MLX4_CORE_GEN2=y
# CONFIG_MLX5_CORE is not set
# CONFIG_MLXSW_CORE is not set
# CONFIG_MLXFW is not set
# CONFIG_NET_VENDOR_MICREL is not set
# CONFIG_NET_VENDOR_MICROCHIP is not set
CONFIG_NET_VENDOR_MICROSEMI=y
# CONFIG_MSCC_OCELOT_SWITCH is not set
CONFIG_NET_VENDOR_MYRI=y
CONFIG_MYRI10GE=m
CONFIG_MYRI10GE_DCA=y
# CONFIG_FEALNX is not set
# CONFIG_NET_VENDOR_NATSEMI is not set
CONFIG_NET_VENDOR_NETERION=y
# CONFIG_S2IO is not set
# CONFIG_VXGE is not set
CONFIG_NET_VENDOR_NETRONOME=y
CONFIG_NFP=m
CONFIG_NFP_APP_FLOWER=y
CONFIG_NFP_APP_ABM_NIC=y
# CONFIG_NFP_DEBUG is not set
CONFIG_NET_VENDOR_NI=y
# CONFIG_NI_XGE_MANAGEMENT_ENET is not set
# CONFIG_NET_VENDOR_NVIDIA is not set
CONFIG_NET_VENDOR_OKI=y
CONFIG_ETHOC=m
CONFIG_NET_VENDOR_PACKET_ENGINES=y
# CONFIG_HAMACHI is not set
CONFIG_YELLOWFIN=m
CONFIG_NET_VENDOR_PENSANDO=y
# CONFIG_IONIC is not set
CONFIG_NET_VENDOR_QLOGIC=y
CONFIG_QLA3XXX=m
CONFIG_QLCNIC=m
CONFIG_QLCNIC_SRIOV=y
CONFIG_QLCNIC_DCB=y
CONFIG_QLCNIC_HWMON=y
CONFIG_NETXEN_NIC=m
CONFIG_QED=m
CONFIG_QED_SRIOV=y
CONFIG_QEDE=m
CONFIG_NET_VENDOR_QUALCOMM=y
# CONFIG_QCOM_EMAC is not set
# CONFIG_RMNET is not set
# CONFIG_NET_VENDOR_RDC is not set
CONFIG_NET_VENDOR_REALTEK=y
# CONFIG_ATP is not set
CONFIG_8139CP=y
CONFIG_8139TOO=y
# CONFIG_8139TOO_PIO is not set
# CONFIG_8139TOO_TUNE_TWISTER is not set
CONFIG_8139TOO_8129=y
# CONFIG_8139_OLD_RX_RESET is not set
CONFIG_R8169=y
CONFIG_NET_VENDOR_RENESAS=y
CONFIG_NET_VENDOR_ROCKER=y
CONFIG_ROCKER=m
CONFIG_NET_VENDOR_SAMSUNG=y
# CONFIG_SXGBE_ETH is not set
# CONFIG_NET_VENDOR_SEEQ is not set
CONFIG_NET_VENDOR_SOLARFLARE=y
CONFIG_SFC=m
CONFIG_SFC_MTD=y
CONFIG_SFC_MCDI_MON=y
CONFIG_SFC_SRIOV=y
CONFIG_SFC_MCDI_LOGGING=y
CONFIG_SFC_FALCON=m
CONFIG_SFC_FALCON_MTD=y
# CONFIG_NET_VENDOR_SILAN is not set
# CONFIG_NET_VENDOR_SIS is not set
CONFIG_NET_VENDOR_SMSC=y
CONFIG_EPIC100=m
# CONFIG_SMSC911X is not set
CONFIG_SMSC9420=m
CONFIG_NET_VENDOR_SOCIONEXT=y
# CONFIG_NET_VENDOR_STMICRO is not set
# CONFIG_NET_VENDOR_SUN is not set
CONFIG_NET_VENDOR_SYNOPSYS=y
# CONFIG_DWC_XLGMAC is not set
# CONFIG_NET_VENDOR_TEHUTI is not set
CONFIG_NET_VENDOR_TI=y
# CONFIG_TI_CPSW_PHY_SEL is not set
CONFIG_TLAN=m
# CONFIG_NET_VENDOR_VIA is not set
# CONFIG_NET_VENDOR_WIZNET is not set
CONFIG_NET_VENDOR_XILINX=y
# CONFIG_XILINX_AXI_EMAC is not set
# CONFIG_XILINX_LL_TEMAC is not set
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
# CONFIG_NET_SB1000 is not set
CONFIG_MDIO_DEVICE=y
CONFIG_MDIO_BUS=y
# CONFIG_MDIO_BCM_UNIMAC is not set
CONFIG_MDIO_BITBANG=m
# CONFIG_MDIO_GPIO is not set
# CONFIG_MDIO_MSCC_MIIM is not set
# CONFIG_MDIO_THUNDER is not set
CONFIG_PHYLINK=m
CONFIG_PHYLIB=y
CONFIG_SWPHY=y
# CONFIG_LED_TRIGGER_PHY is not set

#
# MII PHY device drivers
#
# CONFIG_SFP is not set
# CONFIG_ADIN_PHY is not set
CONFIG_AMD_PHY=m
# CONFIG_AQUANTIA_PHY is not set
# CONFIG_AX88796B_PHY is not set
# CONFIG_BCM7XXX_PHY is not set
CONFIG_BCM87XX_PHY=m
CONFIG_BCM_NET_PHYLIB=m
CONFIG_BROADCOM_PHY=m
# CONFIG_BCM84881_PHY is not set
CONFIG_CICADA_PHY=m
# CONFIG_CORTINA_PHY is not set
CONFIG_DAVICOM_PHY=m
# CONFIG_DP83822_PHY is not set
# CONFIG_DP83TC811_PHY is not set
# CONFIG_DP83848_PHY is not set
# CONFIG_DP83867_PHY is not set
# CONFIG_DP83869_PHY is not set
CONFIG_FIXED_PHY=y
CONFIG_ICPLUS_PHY=m
# CONFIG_INTEL_XWAY_PHY is not set
CONFIG_LSI_ET1011C_PHY=m
CONFIG_LXT_PHY=m
CONFIG_MARVELL_PHY=m
# CONFIG_MARVELL_10G_PHY is not set
CONFIG_MICREL_PHY=m
# CONFIG_MICROCHIP_PHY is not set
# CONFIG_MICROCHIP_T1_PHY is not set
# CONFIG_MICROSEMI_PHY is not set
CONFIG_NATIONAL_PHY=m
# CONFIG_NXP_TJA11XX_PHY is not set
CONFIG_QSEMI_PHY=m
CONFIG_REALTEK_PHY=y
# CONFIG_RENESAS_PHY is not set
# CONFIG_ROCKCHIP_PHY is not set
CONFIG_SMSC_PHY=m
CONFIG_STE10XP=m
# CONFIG_TERANETICS_PHY is not set
CONFIG_VITESSE_PHY=m
# CONFIG_XILINX_GMII2RGMII is not set
# CONFIG_MICREL_KS8995MA is not set
# CONFIG_PLIP is not set
CONFIG_PPP=m
CONFIG_PPP_BSDCOMP=m
CONFIG_PPP_DEFLATE=m
CONFIG_PPP_FILTER=y
CONFIG_PPP_MPPE=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPPOATM=m
CONFIG_PPPOE=m
CONFIG_PPTP=m
CONFIG_PPPOL2TP=m
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
CONFIG_SLIP=m
CONFIG_SLHC=m
CONFIG_SLIP_COMPRESSED=y
CONFIG_SLIP_SMART=y
# CONFIG_SLIP_MODE_SLIP6 is not set
CONFIG_USB_NET_DRIVERS=y
CONFIG_USB_CATC=y
CONFIG_USB_KAWETH=y
CONFIG_USB_PEGASUS=y
CONFIG_USB_RTL8150=y
CONFIG_USB_RTL8152=m
# CONFIG_USB_LAN78XX is not set
CONFIG_USB_USBNET=y
CONFIG_USB_NET_AX8817X=y
CONFIG_USB_NET_AX88179_178A=m
CONFIG_USB_NET_CDCETHER=y
CONFIG_USB_NET_CDC_EEM=y
CONFIG_USB_NET_CDC_NCM=m
CONFIG_USB_NET_HUAWEI_CDC_NCM=m
CONFIG_USB_NET_CDC_MBIM=m
CONFIG_USB_NET_DM9601=y
# CONFIG_USB_NET_SR9700 is not set
# CONFIG_USB_NET_SR9800 is not set
CONFIG_USB_NET_SMSC75XX=y
CONFIG_USB_NET_SMSC95XX=y
CONFIG_USB_NET_GL620A=y
CONFIG_USB_NET_NET1080=y
CONFIG_USB_NET_PLUSB=y
CONFIG_USB_NET_MCS7830=y
CONFIG_USB_NET_RNDIS_HOST=y
CONFIG_USB_NET_CDC_SUBSET_ENABLE=y
CONFIG_USB_NET_CDC_SUBSET=y
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
CONFIG_USB_KC2190=y
CONFIG_USB_NET_ZAURUS=y
CONFIG_USB_NET_CX82310_ETH=m
CONFIG_USB_NET_KALMIA=m
CONFIG_USB_NET_QMI_WWAN=m
CONFIG_USB_HSO=m
CONFIG_USB_NET_INT51X1=y
CONFIG_USB_IPHETH=y
CONFIG_USB_SIERRA_NET=y
CONFIG_USB_VL600=m
# CONFIG_USB_NET_CH9200 is not set
# CONFIG_USB_NET_AQC111 is not set
CONFIG_WLAN=y
# CONFIG_WIRELESS_WDS is not set
CONFIG_WLAN_VENDOR_ADMTEK=y
# CONFIG_ADM8211 is not set
CONFIG_ATH_COMMON=m
CONFIG_WLAN_VENDOR_ATH=y
# CONFIG_ATH_DEBUG is not set
# CONFIG_ATH5K is not set
# CONFIG_ATH5K_PCI is not set
CONFIG_ATH9K_HW=m
CONFIG_ATH9K_COMMON=m
CONFIG_ATH9K_BTCOEX_SUPPORT=y
# CONFIG_ATH9K is not set
CONFIG_ATH9K_HTC=m
# CONFIG_ATH9K_HTC_DEBUGFS is not set
# CONFIG_CARL9170 is not set
# CONFIG_ATH6KL is not set
# CONFIG_AR5523 is not set
# CONFIG_WIL6210 is not set
# CONFIG_ATH10K is not set
# CONFIG_WCN36XX is not set
CONFIG_WLAN_VENDOR_ATMEL=y
# CONFIG_ATMEL is not set
# CONFIG_AT76C50X_USB is not set
CONFIG_WLAN_VENDOR_BROADCOM=y
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
# CONFIG_BRCMSMAC is not set
# CONFIG_BRCMFMAC is not set
CONFIG_WLAN_VENDOR_CISCO=y
# CONFIG_AIRO is not set
CONFIG_WLAN_VENDOR_INTEL=y
# CONFIG_IPW2100 is not set
# CONFIG_IPW2200 is not set
CONFIG_IWLEGACY=m
CONFIG_IWL4965=m
CONFIG_IWL3945=m

#
# iwl3945 / iwl4965 Debugging Options
#
CONFIG_IWLEGACY_DEBUG=y
CONFIG_IWLEGACY_DEBUGFS=y
# end of iwl3945 / iwl4965 Debugging Options

CONFIG_IWLWIFI=m
CONFIG_IWLWIFI_LEDS=y
CONFIG_IWLDVM=m
CONFIG_IWLMVM=m
CONFIG_IWLWIFI_OPMODE_MODULAR=y
# CONFIG_IWLWIFI_BCAST_FILTERING is not set

#
# Debugging Options
#
# CONFIG_IWLWIFI_DEBUG is not set
CONFIG_IWLWIFI_DEBUGFS=y
# CONFIG_IWLWIFI_DEVICE_TRACING is not set
# end of Debugging Options

CONFIG_WLAN_VENDOR_INTERSIL=y
# CONFIG_HOSTAP is not set
# CONFIG_HERMES is not set
# CONFIG_P54_COMMON is not set
# CONFIG_PRISM54 is not set
CONFIG_WLAN_VENDOR_MARVELL=y
# CONFIG_LIBERTAS is not set
# CONFIG_LIBERTAS_THINFIRM is not set
# CONFIG_MWIFIEX is not set
# CONFIG_MWL8K is not set
CONFIG_WLAN_VENDOR_MEDIATEK=y
# CONFIG_MT7601U is not set
# CONFIG_MT76x0U is not set
# CONFIG_MT76x0E is not set
# CONFIG_MT76x2E is not set
# CONFIG_MT76x2U is not set
# CONFIG_MT7603E is not set
# CONFIG_MT7615E is not set
CONFIG_WLAN_VENDOR_RALINK=y
# CONFIG_RT2X00 is not set
CONFIG_WLAN_VENDOR_REALTEK=y
# CONFIG_RTL8180 is not set
# CONFIG_RTL8187 is not set
# CONFIG_RTL_CARDS is not set
# CONFIG_RTL8XXXU is not set
# CONFIG_RTW88 is not set
CONFIG_WLAN_VENDOR_RSI=y
# CONFIG_RSI_91X is not set
CONFIG_WLAN_VENDOR_ST=y
# CONFIG_CW1200 is not set
CONFIG_WLAN_VENDOR_TI=y
# CONFIG_WL1251 is not set
# CONFIG_WL12XX is not set
# CONFIG_WL18XX is not set
# CONFIG_WLCORE is not set
CONFIG_WLAN_VENDOR_ZYDAS=y
# CONFIG_USB_ZD1201 is not set
# CONFIG_ZD1211RW is not set
CONFIG_WLAN_VENDOR_QUANTENNA=y
# CONFIG_QTNFMAC_PCIE is not set
CONFIG_MAC80211_HWSIM=m
# CONFIG_USB_NET_RNDIS_WLAN is not set
# CONFIG_VIRT_WIFI is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
CONFIG_WAN=y
# CONFIG_LANMEDIA is not set
CONFIG_HDLC=m
CONFIG_HDLC_RAW=m
# CONFIG_HDLC_RAW_ETH is not set
CONFIG_HDLC_CISCO=m
CONFIG_HDLC_FR=m
CONFIG_HDLC_PPP=m

#
# X.25/LAPB support is disabled
#
# CONFIG_PCI200SYN is not set
# CONFIG_WANXL is not set
# CONFIG_PC300TOO is not set
# CONFIG_FARSYNC is not set
CONFIG_DLCI=m
CONFIG_DLCI_MAX=8
# CONFIG_SBNI is not set
CONFIG_IEEE802154_DRIVERS=m
CONFIG_IEEE802154_FAKELB=m
# CONFIG_IEEE802154_AT86RF230 is not set
# CONFIG_IEEE802154_MRF24J40 is not set
# CONFIG_IEEE802154_CC2520 is not set
# CONFIG_IEEE802154_ATUSB is not set
# CONFIG_IEEE802154_ADF7242 is not set
# CONFIG_IEEE802154_CA8210 is not set
# CONFIG_IEEE802154_MCR20A is not set
# CONFIG_IEEE802154_HWSIM is not set
CONFIG_XEN_NETDEV_FRONTEND=m
CONFIG_VMXNET3=m
CONFIG_FUJITSU_ES=m
CONFIG_HYPERV_NET=m
CONFIG_NETDEVSIM=m
CONFIG_NET_FAILOVER=m
CONFIG_ISDN=y
CONFIG_ISDN_CAPI=y
CONFIG_CAPI_TRACE=y
CONFIG_ISDN_CAPI_MIDDLEWARE=y
CONFIG_MISDN=m
CONFIG_MISDN_DSP=m
CONFIG_MISDN_L1OIP=m

#
# mISDN hardware drivers
#
CONFIG_MISDN_HFCPCI=m
CONFIG_MISDN_HFCMULTI=m
CONFIG_MISDN_HFCUSB=m
CONFIG_MISDN_AVMFRITZ=m
CONFIG_MISDN_SPEEDFAX=m
CONFIG_MISDN_INFINEON=m
CONFIG_MISDN_W6692=m
CONFIG_MISDN_NETJET=m
CONFIG_MISDN_HDLC=m
CONFIG_MISDN_IPAC=m
CONFIG_MISDN_ISAR=m
CONFIG_NVM=y
# CONFIG_NVM_PBLK is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_LEDS=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=m
CONFIG_INPUT_SPARSEKMAP=m
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADC is not set
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
# CONFIG_KEYBOARD_APPLESPI is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1050 is not set
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_DLINK_DIR685 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_SAMSUNG is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_TM2_TOUCHKEY is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_BYD=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_SYNAPTICS_SMBUS=y
CONFIG_MOUSE_PS2_CYPRESS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_ELANTECH_SMBUS=y
CONFIG_MOUSE_PS2_SENTELIC=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_PS2_FOCALTECH=y
CONFIG_MOUSE_PS2_VMMOUSE=y
CONFIG_MOUSE_PS2_SMBUS=y
CONFIG_MOUSE_SERIAL=m
CONFIG_MOUSE_APPLETOUCH=m
CONFIG_MOUSE_BCM5974=m
CONFIG_MOUSE_CYAPA=m
# CONFIG_MOUSE_ELAN_I2C is not set
CONFIG_MOUSE_VSXXXAA=m
# CONFIG_MOUSE_GPIO is not set
CONFIG_MOUSE_SYNAPTICS_I2C=m
CONFIG_MOUSE_SYNAPTICS_USB=m
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=m
CONFIG_TABLET_USB_AIPTEK=m
CONFIG_TABLET_USB_GTCO=m
# CONFIG_TABLET_USB_HANWANG is not set
CONFIG_TABLET_USB_KBTAB=m
# CONFIG_TABLET_USB_PEGASUS is not set
# CONFIG_TABLET_SERIAL_WACOM4 is not set
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_PROPERTIES=y
# CONFIG_TOUCHSCREEN_ADS7846 is not set
# CONFIG_TOUCHSCREEN_AD7877 is not set
# CONFIG_TOUCHSCREEN_AD7879 is not set
# CONFIG_TOUCHSCREEN_ADC is not set
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
# CONFIG_TOUCHSCREEN_AUO_PIXCIR is not set
# CONFIG_TOUCHSCREEN_BU21013 is not set
# CONFIG_TOUCHSCREEN_BU21029 is not set
# CONFIG_TOUCHSCREEN_CHIPONE_ICN8505 is not set
# CONFIG_TOUCHSCREEN_CY8CTMG110 is not set
# CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
# CONFIG_TOUCHSCREEN_CYTTSP4_CORE is not set
# CONFIG_TOUCHSCREEN_DYNAPRO is not set
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
# CONFIG_TOUCHSCREEN_EETI is not set
# CONFIG_TOUCHSCREEN_EGALAX_SERIAL is not set
# CONFIG_TOUCHSCREEN_EXC3000 is not set
# CONFIG_TOUCHSCREEN_FUJITSU is not set
# CONFIG_TOUCHSCREEN_GOODIX is not set
# CONFIG_TOUCHSCREEN_HIDEEP is not set
# CONFIG_TOUCHSCREEN_ILI210X is not set
# CONFIG_TOUCHSCREEN_S6SY761 is not set
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_EKTF2127 is not set
# CONFIG_TOUCHSCREEN_ELAN is not set
CONFIG_TOUCHSCREEN_ELO=m
CONFIG_TOUCHSCREEN_WACOM_W8001=m
CONFIG_TOUCHSCREEN_WACOM_I2C=m
# CONFIG_TOUCHSCREEN_MAX11801 is not set
# CONFIG_TOUCHSCREEN_MCS5000 is not set
# CONFIG_TOUCHSCREEN_MMS114 is not set
# CONFIG_TOUCHSCREEN_MELFAS_MIP4 is not set
# CONFIG_TOUCHSCREEN_MTOUCH is not set
# CONFIG_TOUCHSCREEN_INEXIO is not set
# CONFIG_TOUCHSCREEN_MK712 is not set
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
# CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
# CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
# CONFIG_TOUCHSCREEN_PIXCIR is not set
# CONFIG_TOUCHSCREEN_WDT87XX_I2C is not set
# CONFIG_TOUCHSCREEN_WM97XX is not set
# CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
# CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
# CONFIG_TOUCHSCREEN_TSC_SERIO is not set
# CONFIG_TOUCHSCREEN_TSC2004 is not set
# CONFIG_TOUCHSCREEN_TSC2005 is not set
# CONFIG_TOUCHSCREEN_TSC2007 is not set
# CONFIG_TOUCHSCREEN_RM_TS is not set
# CONFIG_TOUCHSCREEN_SILEAD is not set
# CONFIG_TOUCHSCREEN_SIS_I2C is not set
# CONFIG_TOUCHSCREEN_ST1232 is not set
# CONFIG_TOUCHSCREEN_STMFTS is not set
# CONFIG_TOUCHSCREEN_SUR40 is not set
# CONFIG_TOUCHSCREEN_SURFACE3_SPI is not set
# CONFIG_TOUCHSCREEN_SX8654 is not set
# CONFIG_TOUCHSCREEN_TPS6507X is not set
# CONFIG_TOUCHSCREEN_ZET6223 is not set
# CONFIG_TOUCHSCREEN_ZFORCE is not set
# CONFIG_TOUCHSCREEN_ROHM_BU21023 is not set
# CONFIG_TOUCHSCREEN_IQS5XX is not set
CONFIG_INPUT_MISC=y
# CONFIG_INPUT_AD714X is not set
# CONFIG_INPUT_BMA150 is not set
# CONFIG_INPUT_E3X0_BUTTON is not set
# CONFIG_INPUT_MSM_VIBRATOR is not set
CONFIG_INPUT_PCSPKR=m
# CONFIG_INPUT_MMA8450 is not set
CONFIG_INPUT_APANEL=m
CONFIG_INPUT_GP2A=m
# CONFIG_INPUT_GPIO_BEEPER is not set
# CONFIG_INPUT_GPIO_DECODER is not set
# CONFIG_INPUT_GPIO_VIBRA is not set
CONFIG_INPUT_ATLAS_BTNS=m
CONFIG_INPUT_ATI_REMOTE2=m
CONFIG_INPUT_KEYSPAN_REMOTE=m
# CONFIG_INPUT_KXTJ9 is not set
CONFIG_INPUT_POWERMATE=m
CONFIG_INPUT_YEALINK=m
CONFIG_INPUT_CM109=m
CONFIG_INPUT_UINPUT=m
# CONFIG_INPUT_PCF8574 is not set
# CONFIG_INPUT_PWM_BEEPER is not set
# CONFIG_INPUT_PWM_VIBRA is not set
CONFIG_INPUT_GPIO_ROTARY_ENCODER=m
# CONFIG_INPUT_ADXL34X is not set
# CONFIG_INPUT_IMS_PCU is not set
# CONFIG_INPUT_CMA3000 is not set
CONFIG_INPUT_XEN_KBDDEV_FRONTEND=m
# CONFIG_INPUT_IDEAPAD_SLIDEBAR is not set
# CONFIG_INPUT_DRV260X_HAPTICS is not set
# CONFIG_INPUT_DRV2665_HAPTICS is not set
# CONFIG_INPUT_DRV2667_HAPTICS is not set
CONFIG_RMI4_CORE=m
# CONFIG_RMI4_I2C is not set
# CONFIG_RMI4_SPI is not set
CONFIG_RMI4_SMB=m
CONFIG_RMI4_F03=y
CONFIG_RMI4_F03_SERIO=m
CONFIG_RMI4_2D_SENSOR=y
CONFIG_RMI4_F11=y
CONFIG_RMI4_F12=y
CONFIG_RMI4_F30=y
# CONFIG_RMI4_F34 is not set
# CONFIG_RMI4_F54 is not set
# CONFIG_RMI4_F55 is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
CONFIG_SERIO_ALTERA_PS2=m
# CONFIG_SERIO_PS2MULT is not set
CONFIG_SERIO_ARC_PS2=m
CONFIG_HYPERV_KEYBOARD=m
# CONFIG_SERIO_GPIO_PS2 is not set
# CONFIG_USERIO is not set
# CONFIG_GAMEPORT is not set
# end of Hardware I/O ports
# end of Input device support

#
# Character devices
#
CONFIG_TTY=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_VT_CONSOLE_SLEEP=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
# CONFIG_LEGACY_PTYS is not set
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_ROCKETPORT is not set
CONFIG_CYCLADES=m
# CONFIG_CYZ_INTR is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
CONFIG_SYNCLINK=m
CONFIG_SYNCLINKMP=m
CONFIG_SYNCLINK_GT=m
CONFIG_NOZOMI=m
# CONFIG_ISI is not set
CONFIG_N_HDLC=m
CONFIG_N_GSM=m
# CONFIG_TRACE_SINK is not set
# CONFIG_NULL_TTY is not set
CONFIG_LDISC_AUTOLOAD=y
CONFIG_DEVMEM=y
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_EARLYCON=y
CONFIG_SERIAL_8250=y
# CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
CONFIG_SERIAL_8250_PNP=y
# CONFIG_SERIAL_8250_16550A_VARIANTS is not set
# CONFIG_SERIAL_8250_FINTEK is not set
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_8250_DMA=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_EXAR=y
CONFIG_SERIAL_8250_NR_UARTS=32
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
# CONFIG_SERIAL_8250_DETECT_IRQ is not set
CONFIG_SERIAL_8250_RSA=y
CONFIG_SERIAL_8250_DWLIB=y
CONFIG_SERIAL_8250_DW=y
# CONFIG_SERIAL_8250_RT288X is not set
CONFIG_SERIAL_8250_LPSS=y
CONFIG_SERIAL_8250_MID=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX310X is not set
# CONFIG_SERIAL_UARTLITE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=m
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_SC16IS7XX is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_IFX6X60 is not set
CONFIG_SERIAL_ARC=m
CONFIG_SERIAL_ARC_NR_PORTS=1
# CONFIG_SERIAL_RP2 is not set
# CONFIG_SERIAL_FSL_LPUART is not set
# CONFIG_SERIAL_FSL_LINFLEXUART is not set
# end of Serial drivers

CONFIG_SERIAL_MCTRL_GPIO=y
# CONFIG_SERIAL_DEV_BUS is not set
# CONFIG_TTY_PRINTK is not set
CONFIG_PRINTER=m
# CONFIG_LP_CONSOLE is not set
CONFIG_PPDEV=m
CONFIG_HVC_DRIVER=y
CONFIG_HVC_IRQ=y
CONFIG_HVC_XEN=y
CONFIG_HVC_XEN_FRONTEND=y
CONFIG_VIRTIO_CONSOLE=y
CONFIG_IPMI_HANDLER=m
CONFIG_IPMI_DMI_DECODE=y
CONFIG_IPMI_PLAT_DATA=y
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_SSIF=m
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_TIMERIOMEM=m
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
CONFIG_HW_RANDOM_VIA=m
CONFIG_HW_RANDOM_VIRTIO=y
CONFIG_NVRAM=y
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=8192
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
# CONFIG_HPET_MMAP_DEFAULT is not set
CONFIG_HANGCHECK_TIMER=m
CONFIG_UV_MMTIMER=m
CONFIG_TCG_TPM=y
CONFIG_HW_RANDOM_TPM=y
CONFIG_TCG_TIS_CORE=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_TIS_SPI is not set
CONFIG_TCG_TIS_I2C_ATMEL=m
CONFIG_TCG_TIS_I2C_INFINEON=m
CONFIG_TCG_TIS_I2C_NUVOTON=m
CONFIG_TCG_NSC=m
CONFIG_TCG_ATMEL=m
CONFIG_TCG_INFINEON=m
# CONFIG_TCG_XEN is not set
CONFIG_TCG_CRB=y
# CONFIG_TCG_VTPM_PROXY is not set
CONFIG_TCG_TIS_ST33ZP24=m
CONFIG_TCG_TIS_ST33ZP24_I2C=m
# CONFIG_TCG_TIS_ST33ZP24_SPI is not set
CONFIG_TELCLOCK=m
CONFIG_DEVPORT=y
# CONFIG_XILLYBUS is not set
# end of Character devices

# CONFIG_RANDOM_TRUST_CPU is not set
# CONFIG_RANDOM_TRUST_BOOTLOADER is not set

#
# I2C support
#
CONFIG_I2C=y
CONFIG_ACPI_I2C_OPREGION=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_MUX=m

#
# Multiplexer I2C Chip support
#
# CONFIG_I2C_MUX_GPIO is not set
# CONFIG_I2C_MUX_LTC4306 is not set
# CONFIG_I2C_MUX_PCA9541 is not set
# CONFIG_I2C_MUX_PCA954x is not set
# CONFIG_I2C_MUX_REG is not set
# CONFIG_I2C_MUX_MLXCPLD is not set
# end of Multiplexer I2C Chip support

CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=m
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
CONFIG_I2C_AMD756=m
CONFIG_I2C_AMD756_S4882=m
CONFIG_I2C_AMD8111=m
# CONFIG_I2C_AMD_MP2 is not set
CONFIG_I2C_I801=m
CONFIG_I2C_ISCH=m
CONFIG_I2C_ISMT=m
CONFIG_I2C_PIIX4=m
CONFIG_I2C_NFORCE2=m
CONFIG_I2C_NFORCE2_S4985=m
# CONFIG_I2C_NVIDIA_GPU is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
CONFIG_I2C_SIS96X=m
CONFIG_I2C_VIA=m
CONFIG_I2C_VIAPRO=m

#
# ACPI drivers
#
CONFIG_I2C_SCMI=m

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_CBUS_GPIO is not set
CONFIG_I2C_DESIGNWARE_CORE=m
CONFIG_I2C_DESIGNWARE_PLATFORM=m
# CONFIG_I2C_DESIGNWARE_SLAVE is not set
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_DESIGNWARE_BAYTRAIL is not set
# CONFIG_I2C_EMEV2 is not set
# CONFIG_I2C_GPIO is not set
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_PCA_PLATFORM=m
CONFIG_I2C_SIMTEC=m
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_DIOLAN_U2C=m
CONFIG_I2C_PARPORT=m
# CONFIG_I2C_ROBOTFUZZ_OSIF is not set
# CONFIG_I2C_TAOS_EVM is not set
CONFIG_I2C_TINY_USB=m
CONFIG_I2C_VIPERBOARD=m

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_MLXCPLD is not set
# end of I2C Hardware Bus support

CONFIG_I2C_STUB=m
# CONFIG_I2C_SLAVE is not set
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# end of I2C support

# CONFIG_I3C is not set
CONFIG_SPI=y
# CONFIG_SPI_DEBUG is not set
CONFIG_SPI_MASTER=y
# CONFIG_SPI_MEM is not set

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_ALTERA is not set
# CONFIG_SPI_AXI_SPI_ENGINE is not set
# CONFIG_SPI_BITBANG is not set
# CONFIG_SPI_BUTTERFLY is not set
# CONFIG_SPI_CADENCE is not set
# CONFIG_SPI_DESIGNWARE is not set
# CONFIG_SPI_NXP_FLEXSPI is not set
# CONFIG_SPI_GPIO is not set
# CONFIG_SPI_LM70_LLP is not set
# CONFIG_SPI_OC_TINY is not set
CONFIG_SPI_PXA2XX=m
CONFIG_SPI_PXA2XX_PCI=m
# CONFIG_SPI_ROCKCHIP is not set
# CONFIG_SPI_SC18IS602 is not set
# CONFIG_SPI_SIFIVE is not set
# CONFIG_SPI_MXIC is not set
# CONFIG_SPI_XCOMM is not set
# CONFIG_SPI_XILINX is not set
# CONFIG_SPI_ZYNQMP_GQSPI is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_SPIDEV is not set
# CONFIG_SPI_LOOPBACK_TEST is not set
# CONFIG_SPI_TLE62X0 is not set
# CONFIG_SPI_SLAVE is not set
# CONFIG_SPMI is not set
# CONFIG_HSI is not set
CONFIG_PPS=y
# CONFIG_PPS_DEBUG is not set

#
# PPS clients support
#
# CONFIG_PPS_CLIENT_KTIMER is not set
CONFIG_PPS_CLIENT_LDISC=m
CONFIG_PPS_CLIENT_PARPORT=m
CONFIG_PPS_CLIENT_GPIO=m

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=y
CONFIG_DP83640_PHY=m
# CONFIG_PTP_1588_CLOCK_INES is not set
CONFIG_PTP_1588_CLOCK_KVM=m
# CONFIG_PTP_1588_CLOCK_IDTCM is not set
# end of PTP clock support

CONFIG_PINCTRL=y
CONFIG_PINMUX=y
CONFIG_PINCONF=y
CONFIG_GENERIC_PINCONF=y
# CONFIG_DEBUG_PINCTRL is not set
CONFIG_PINCTRL_AMD=m
# CONFIG_PINCTRL_MCP23S08 is not set
# CONFIG_PINCTRL_SX150X is not set
CONFIG_PINCTRL_BAYTRAIL=y
# CONFIG_PINCTRL_CHERRYVIEW is not set
# CONFIG_PINCTRL_LYNXPOINT is not set
CONFIG_PINCTRL_INTEL=m
# CONFIG_PINCTRL_BROXTON is not set
CONFIG_PINCTRL_CANNONLAKE=m
# CONFIG_PINCTRL_CEDARFORK is not set
CONFIG_PINCTRL_DENVERTON=m
CONFIG_PINCTRL_GEMINILAKE=m
# CONFIG_PINCTRL_ICELAKE is not set
CONFIG_PINCTRL_LEWISBURG=m
CONFIG_PINCTRL_SUNRISEPOINT=m
# CONFIG_PINCTRL_TIGERLAKE is not set
CONFIG_GPIOLIB=y
CONFIG_GPIOLIB_FASTPATH_LIMIT=512
CONFIG_GPIO_ACPI=y
CONFIG_GPIOLIB_IRQCHIP=y
# CONFIG_DEBUG_GPIO is not set
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=m

#
# Memory mapped GPIO drivers
#
CONFIG_GPIO_AMDPT=m
# CONFIG_GPIO_DWAPB is not set
# CONFIG_GPIO_EXAR is not set
# CONFIG_GPIO_GENERIC_PLATFORM is not set
CONFIG_GPIO_ICH=m
# CONFIG_GPIO_MB86S7X is not set
# CONFIG_GPIO_VX855 is not set
# CONFIG_GPIO_XILINX is not set
# CONFIG_GPIO_AMD_FCH is not set
# end of Memory mapped GPIO drivers

#
# Port-mapped I/O GPIO drivers
#
# CONFIG_GPIO_F7188X is not set
# CONFIG_GPIO_IT87 is not set
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_SCH311X is not set
# CONFIG_GPIO_WINBOND is not set
# CONFIG_GPIO_WS16C48 is not set
# end of Port-mapped I/O GPIO drivers

#
# I2C GPIO expanders
#
# CONFIG_GPIO_ADP5588 is not set
# CONFIG_GPIO_MAX7300 is not set
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
# CONFIG_GPIO_PCF857X is not set
# CONFIG_GPIO_TPIC2810 is not set
# end of I2C GPIO expanders

#
# MFD GPIO expanders
#
# end of MFD GPIO expanders

#
# PCI GPIO expanders
#
# CONFIG_GPIO_AMD8111 is not set
# CONFIG_GPIO_ML_IOH is not set
# CONFIG_GPIO_PCI_IDIO_16 is not set
# CONFIG_GPIO_PCIE_IDIO_24 is not set
# CONFIG_GPIO_RDC321X is not set
# end of PCI GPIO expanders

#
# SPI GPIO expanders
#
# CONFIG_GPIO_MAX3191X is not set
# CONFIG_GPIO_MAX7301 is not set
# CONFIG_GPIO_MC33880 is not set
# CONFIG_GPIO_PISOSR is not set
# CONFIG_GPIO_XRA1403 is not set
# end of SPI GPIO expanders

#
# USB GPIO expanders
#
CONFIG_GPIO_VIPERBOARD=m
# end of USB GPIO expanders

CONFIG_GPIO_MOCKUP=y
# CONFIG_W1 is not set
# CONFIG_POWER_AVS is not set
CONFIG_POWER_RESET=y
# CONFIG_POWER_RESET_RESTART is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_POWER_SUPPLY_HWMON=y
# CONFIG_PDA_POWER is not set
# CONFIG_GENERIC_ADC_BATTERY is not set
# CONFIG_TEST_POWER is not set
# CONFIG_CHARGER_ADP5061 is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_CHARGER_SBS is not set
# CONFIG_MANAGER_SBS is not set
# CONFIG_BATTERY_BQ27XXX is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_LT3651 is not set
# CONFIG_CHARGER_BQ2415X is not set
# CONFIG_CHARGER_BQ24257 is not set
# CONFIG_CHARGER_BQ24735 is not set
# CONFIG_CHARGER_BQ25890 is not set
CONFIG_CHARGER_SMB347=m
# CONFIG_BATTERY_GAUGE_LTC2941 is not set
# CONFIG_CHARGER_RT9455 is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=m
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=m
CONFIG_SENSORS_ABITUGURU3=m
# CONFIG_SENSORS_AD7314 is not set
CONFIG_SENSORS_AD7414=m
CONFIG_SENSORS_AD7418=m
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=m
# CONFIG_SENSORS_ADM1177 is not set
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7X10=m
# CONFIG_SENSORS_ADT7310 is not set
CONFIG_SENSORS_ADT7410=m
CONFIG_SENSORS_ADT7411=m
CONFIG_SENSORS_ADT7462=m
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=m
# CONFIG_SENSORS_AS370 is not set
CONFIG_SENSORS_ASC7621=m
CONFIG_SENSORS_K8TEMP=m
CONFIG_SENSORS_K10TEMP=m
CONFIG_SENSORS_FAM15H_POWER=m
CONFIG_SENSORS_APPLESMC=m
CONFIG_SENSORS_ASB100=m
# CONFIG_SENSORS_ASPEED is not set
CONFIG_SENSORS_ATXP1=m
# CONFIG_SENSORS_DRIVETEMP is not set
CONFIG_SENSORS_DS620=m
CONFIG_SENSORS_DS1621=m
CONFIG_SENSORS_DELL_SMM=m
CONFIG_SENSORS_I5K_AMB=m
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHMD=m
# CONFIG_SENSORS_FTSTEUTATES is not set
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_G760A=m
# CONFIG_SENSORS_G762 is not set
# CONFIG_SENSORS_HIH6130 is not set
CONFIG_SENSORS_IBMAEM=m
CONFIG_SENSORS_IBMPEX=m
# CONFIG_SENSORS_IIO_HWMON is not set
# CONFIG_SENSORS_I5500 is not set
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_IT87=m
CONFIG_SENSORS_JC42=m
# CONFIG_SENSORS_POWR1220 is not set
CONFIG_SENSORS_LINEAGE=m
# CONFIG_SENSORS_LTC2945 is not set
# CONFIG_SENSORS_LTC2947_I2C is not set
# CONFIG_SENSORS_LTC2947_SPI is not set
# CONFIG_SENSORS_LTC2990 is not set
CONFIG_SENSORS_LTC4151=m
CONFIG_SENSORS_LTC4215=m
# CONFIG_SENSORS_LTC4222 is not set
CONFIG_SENSORS_LTC4245=m
# CONFIG_SENSORS_LTC4260 is not set
CONFIG_SENSORS_LTC4261=m
# CONFIG_SENSORS_MAX1111 is not set
CONFIG_SENSORS_MAX16065=m
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX1668=m
CONFIG_SENSORS_MAX197=m
# CONFIG_SENSORS_MAX31722 is not set
# CONFIG_SENSORS_MAX31730 is not set
# CONFIG_SENSORS_MAX6621 is not set
CONFIG_SENSORS_MAX6639=m
CONFIG_SENSORS_MAX6642=m
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_MAX6697=m
# CONFIG_SENSORS_MAX31790 is not set
CONFIG_SENSORS_MCP3021=m
# CONFIG_SENSORS_TC654 is not set
# CONFIG_SENSORS_ADCXX is not set
CONFIG_SENSORS_LM63=m
# CONFIG_SENSORS_LM70 is not set
CONFIG_SENSORS_LM73=m
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=m
CONFIG_SENSORS_LM95234=m
CONFIG_SENSORS_LM95241=m
CONFIG_SENSORS_LM95245=m
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_NTC_THERMISTOR=m
# CONFIG_SENSORS_NCT6683 is not set
CONFIG_SENSORS_NCT6775=m
# CONFIG_SENSORS_NCT7802 is not set
# CONFIG_SENSORS_NCT7904 is not set
# CONFIG_SENSORS_NPCM7XX is not set
CONFIG_SENSORS_PCF8591=m
CONFIG_PMBUS=m
CONFIG_SENSORS_PMBUS=m
CONFIG_SENSORS_ADM1275=m
# CONFIG_SENSORS_BEL_PFE is not set
# CONFIG_SENSORS_IBM_CFFPS is not set
# CONFIG_SENSORS_INSPUR_IPSPS is not set
# CONFIG_SENSORS_IR35221 is not set
# CONFIG_SENSORS_IR38064 is not set
# CONFIG_SENSORS_IRPS5401 is not set
# CONFIG_SENSORS_ISL68137 is not set
CONFIG_SENSORS_LM25066=m
CONFIG_SENSORS_LTC2978=m
# CONFIG_SENSORS_LTC3815 is not set
CONFIG_SENSORS_MAX16064=m
# CONFIG_SENSORS_MAX20730 is not set
# CONFIG_SENSORS_MAX20751 is not set
# CONFIG_SENSORS_MAX31785 is not set
CONFIG_SENSORS_MAX34440=m
CONFIG_SENSORS_MAX8688=m
# CONFIG_SENSORS_PXE1610 is not set
# CONFIG_SENSORS_TPS40422 is not set
# CONFIG_SENSORS_TPS53679 is not set
CONFIG_SENSORS_UCD9000=m
CONFIG_SENSORS_UCD9200=m
# CONFIG_SENSORS_XDPE122 is not set
CONFIG_SENSORS_ZL6100=m
CONFIG_SENSORS_SHT15=m
CONFIG_SENSORS_SHT21=m
# CONFIG_SENSORS_SHT3x is not set
# CONFIG_SENSORS_SHTC1 is not set
CONFIG_SENSORS_SIS5595=m
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_EMC1403=m
# CONFIG_SENSORS_EMC2103 is not set
CONFIG_SENSORS_EMC6W201=m
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
CONFIG_SENSORS_SCH56XX_COMMON=m
CONFIG_SENSORS_SCH5627=m
CONFIG_SENSORS_SCH5636=m
# CONFIG_SENSORS_STTS751 is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_ADC128D818 is not set
CONFIG_SENSORS_ADS7828=m
# CONFIG_SENSORS_ADS7871 is not set
CONFIG_SENSORS_AMC6821=m
CONFIG_SENSORS_INA209=m
CONFIG_SENSORS_INA2XX=m
# CONFIG_SENSORS_INA3221 is not set
# CONFIG_SENSORS_TC74 is not set
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_TMP102=m
# CONFIG_SENSORS_TMP103 is not set
# CONFIG_SENSORS_TMP108 is not set
CONFIG_SENSORS_TMP401=m
CONFIG_SENSORS_TMP421=m
# CONFIG_SENSORS_TMP513 is not set
CONFIG_SENSORS_VIA_CPUTEMP=m
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=m
# CONFIG_SENSORS_W83773G is not set
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83795=m
# CONFIG_SENSORS_W83795_FANCTRL is not set
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
# CONFIG_SENSORS_XGENE is not set

#
# ACPI drivers
#
CONFIG_SENSORS_ACPI_POWER=m
CONFIG_SENSORS_ATK0110=m
CONFIG_THERMAL=y
# CONFIG_THERMAL_STATISTICS is not set
CONFIG_THERMAL_EMERGENCY_POWEROFF_DELAY_MS=0
CONFIG_THERMAL_HWMON=y
CONFIG_THERMAL_WRITABLE_TRIPS=y
CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
# CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_THERMAL_GOV_FAIR_SHARE=y
CONFIG_THERMAL_GOV_STEP_WISE=y
CONFIG_THERMAL_GOV_BANG_BANG=y
CONFIG_THERMAL_GOV_USER_SPACE=y
# CONFIG_CLOCK_THERMAL is not set
# CONFIG_DEVFREQ_THERMAL is not set
# CONFIG_THERMAL_EMULATION is not set

#
# Intel thermal drivers
#
CONFIG_INTEL_POWERCLAMP=m
CONFIG_X86_PKG_TEMP_THERMAL=m
CONFIG_INTEL_SOC_DTS_IOSF_CORE=m
# CONFIG_INTEL_SOC_DTS_THERMAL is not set

#
# ACPI INT340X thermal drivers
#
CONFIG_INT340X_THERMAL=m
CONFIG_ACPI_THERMAL_REL=m
# CONFIG_INT3406_THERMAL is not set
CONFIG_PROC_THERMAL_MMIO_RAPL=y
# end of ACPI INT340X thermal drivers

# CONFIG_INTEL_PCH_THERMAL is not set
# end of Intel thermal drivers

# CONFIG_GENERIC_ADC_THERMAL is not set
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set
CONFIG_WATCHDOG_HANDLE_BOOT_ENABLED=y
CONFIG_WATCHDOG_OPEN_TIMEOUT=0
CONFIG_WATCHDOG_SYSFS=y

#
# Watchdog Pretimeout Governors
#
# CONFIG_WATCHDOG_PRETIMEOUT_GOV is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
CONFIG_WDAT_WDT=m
# CONFIG_XILINX_WATCHDOG is not set
# CONFIG_ZIIRAVE_WATCHDOG is not set
# CONFIG_CADENCE_WATCHDOG is not set
# CONFIG_DW_WATCHDOG is not set
# CONFIG_MAX63XX_WATCHDOG is not set
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
CONFIG_ALIM1535_WDT=m
CONFIG_ALIM7101_WDT=m
# CONFIG_EBC_C384_WDT is not set
CONFIG_F71808E_WDT=m
CONFIG_SP5100_TCO=m
CONFIG_SBC_FITPC2_WATCHDOG=m
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=m
CONFIG_IBMASR=m
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=y
CONFIG_IE6XX_WDT=m
CONFIG_ITCO_WDT=y
CONFIG_ITCO_VENDOR_SUPPORT=y
CONFIG_IT8712F_WDT=m
CONFIG_IT87_WDT=m
CONFIG_HP_WATCHDOG=m
CONFIG_HPWDT_NMI_DECODING=y
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
CONFIG_NV_TCO=m
# CONFIG_60XX_WDT is not set
# CONFIG_CPU5_WDT is not set
CONFIG_SMSC_SCH311X_WDT=m
# CONFIG_SMSC37B787_WDT is not set
# CONFIG_TQMX86_WDT is not set
CONFIG_VIA_WDT=m
CONFIG_W83627HF_WDT=m
CONFIG_W83877F_WDT=m
CONFIG_W83977F_WDT=m
CONFIG_MACHZ_WDT=m
# CONFIG_SBC_EPX_C3_WATCHDOG is not set
CONFIG_INTEL_MEI_WDT=m
# CONFIG_NI903X_WDT is not set
# CONFIG_NIC7018_WDT is not set
# CONFIG_MEN_A21_WDT is not set
CONFIG_XEN_WDT=m

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=m
CONFIG_WDTPCI=m

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=m
CONFIG_SSB_POSSIBLE=y
CONFIG_SSB=m
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
CONFIG_SSB_SDIOHOST_POSSIBLE=y
CONFIG_SSB_SDIOHOST=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
CONFIG_SSB_DRIVER_GPIO=y
CONFIG_BCMA_POSSIBLE=y
CONFIG_BCMA=m
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
# CONFIG_BCMA_HOST_SOC is not set
CONFIG_BCMA_DRIVER_PCI=y
CONFIG_BCMA_DRIVER_GMAC_CMN=y
CONFIG_BCMA_DRIVER_GPIO=y
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_AS3711 is not set
# CONFIG_PMIC_ADP5520 is not set
# CONFIG_MFD_AAT2870_CORE is not set
# CONFIG_MFD_BCM590XX is not set
# CONFIG_MFD_BD9571MWV is not set
# CONFIG_MFD_AXP20X_I2C is not set
# CONFIG_MFD_MADERA is not set
# CONFIG_PMIC_DA903X is not set
# CONFIG_MFD_DA9052_SPI is not set
# CONFIG_MFD_DA9052_I2C is not set
# CONFIG_MFD_DA9055 is not set
# CONFIG_MFD_DA9062 is not set
# CONFIG_MFD_DA9063 is not set
# CONFIG_MFD_DA9150 is not set
# CONFIG_MFD_DLN2 is not set
# CONFIG_MFD_MC13XXX_SPI is not set
# CONFIG_MFD_MC13XXX_I2C is not set
# CONFIG_HTC_PASIC3 is not set
# CONFIG_HTC_I2CPLD is not set
# CONFIG_MFD_INTEL_QUARK_I2C_GPIO is not set
CONFIG_LPC_ICH=m
CONFIG_LPC_SCH=m
# CONFIG_INTEL_SOC_PMIC_CHTDC_TI is not set
CONFIG_MFD_INTEL_LPSS=y
CONFIG_MFD_INTEL_LPSS_ACPI=y
CONFIG_MFD_INTEL_LPSS_PCI=y
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_KEMPLD is not set
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_88PM860X is not set
# CONFIG_MFD_MAX14577 is not set
# CONFIG_MFD_MAX77693 is not set
# CONFIG_MFD_MAX77843 is not set
# CONFIG_MFD_MAX8907 is not set
# CONFIG_MFD_MAX8925 is not set
# CONFIG_MFD_MAX8997 is not set
# CONFIG_MFD_MAX8998 is not set
# CONFIG_MFD_MT6397 is not set
# CONFIG_MFD_MENF21BMC is not set
# CONFIG_EZX_PCAP is not set
CONFIG_MFD_VIPERBOARD=m
# CONFIG_MFD_RETU is not set
# CONFIG_MFD_PCF50633 is not set
# CONFIG_UCB1400_CORE is not set
# CONFIG_MFD_RDC321X is not set
# CONFIG_MFD_RT5033 is not set
# CONFIG_MFD_RC5T583 is not set
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_SI476X_CORE is not set
CONFIG_MFD_SM501=m
CONFIG_MFD_SM501_GPIO=y
# CONFIG_MFD_SKY81452 is not set
# CONFIG_MFD_SMSC is not set
# CONFIG_ABX500_CORE is not set
# CONFIG_MFD_SYSCON is not set
# CONFIG_MFD_TI_AM335X_TSCADC is not set
# CONFIG_MFD_LP3943 is not set
# CONFIG_MFD_LP8788 is not set
# CONFIG_MFD_TI_LMU is not set
# CONFIG_MFD_PALMAS is not set
# CONFIG_TPS6105X is not set
# CONFIG_TPS65010 is not set
# CONFIG_TPS6507X is not set
# CONFIG_MFD_TPS65086 is not set
# CONFIG_MFD_TPS65090 is not set
# CONFIG_MFD_TI_LP873X is not set
# CONFIG_MFD_TPS6586X is not set
# CONFIG_MFD_TPS65910 is not set
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_MFD_TPS65912_SPI is not set
# CONFIG_MFD_TPS80031 is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
# CONFIG_MFD_WL1273_CORE is not set
# CONFIG_MFD_LM3533 is not set
# CONFIG_MFD_TQMX86 is not set
CONFIG_MFD_VX855=m
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_ARIZONA_SPI is not set
# CONFIG_MFD_WM8400 is not set
# CONFIG_MFD_WM831X_I2C is not set
# CONFIG_MFD_WM831X_SPI is not set
# CONFIG_MFD_WM8350_I2C is not set
# CONFIG_MFD_WM8994 is not set
# end of Multifunction device drivers

# CONFIG_REGULATOR is not set
CONFIG_RC_CORE=m
CONFIG_RC_MAP=m
CONFIG_LIRC=y
CONFIG_RC_DECODERS=y
CONFIG_IR_NEC_DECODER=m
CONFIG_IR_RC5_DECODER=m
CONFIG_IR_RC6_DECODER=m
CONFIG_IR_JVC_DECODER=m
CONFIG_IR_SONY_DECODER=m
CONFIG_IR_SANYO_DECODER=m
CONFIG_IR_SHARP_DECODER=m
CONFIG_IR_MCE_KBD_DECODER=m
# CONFIG_IR_XMP_DECODER is not set
CONFIG_IR_IMON_DECODER=m
# CONFIG_IR_RCMM_DECODER is not set
CONFIG_RC_DEVICES=y
CONFIG_RC_ATI_REMOTE=m
CONFIG_IR_ENE=m
CONFIG_IR_IMON=m
# CONFIG_IR_IMON_RAW is not set
CONFIG_IR_MCEUSB=m
CONFIG_IR_ITE_CIR=m
CONFIG_IR_FINTEK=m
CONFIG_IR_NUVOTON=m
CONFIG_IR_REDRAT3=m
CONFIG_IR_STREAMZAP=m
CONFIG_IR_WINBOND_CIR=m
# CONFIG_IR_IGORPLUGUSB is not set
CONFIG_IR_IGUANA=m
CONFIG_IR_TTUSBIR=m
CONFIG_RC_LOOPBACK=m
# CONFIG_IR_SERIAL is not set
# CONFIG_IR_SIR is not set
# CONFIG_RC_XBOX_DVD is not set
CONFIG_MEDIA_SUPPORT=m

#
# Multimedia core support
#
CONFIG_MEDIA_CAMERA_SUPPORT=y
CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
CONFIG_MEDIA_RADIO_SUPPORT=y
# CONFIG_MEDIA_SDR_SUPPORT is not set
# CONFIG_MEDIA_CEC_SUPPORT is not set
CONFIG_MEDIA_CONTROLLER=y
CONFIG_MEDIA_CONTROLLER_DVB=y
CONFIG_VIDEO_DEV=m
# CONFIG_VIDEO_V4L2_SUBDEV_API is not set
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEO_V4L2_I2C=y
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_TUNER=m
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF_DMA_SG=m
CONFIG_VIDEOBUF_VMALLOC=m
CONFIG_DVB_CORE=m
# CONFIG_DVB_MMAP is not set
CONFIG_DVB_NET=y
CONFIG_TTPCI_EEPROM=m
CONFIG_DVB_MAX_ADAPTERS=8
CONFIG_DVB_DYNAMIC_MINORS=y
# CONFIG_DVB_DEMUX_SECTION_LOSS_LOG is not set
# CONFIG_DVB_ULE_DEBUG is not set

#
# Media drivers
#
CONFIG_MEDIA_USB_SUPPORT=y

#
# Webcam devices
#
CONFIG_USB_VIDEO_CLASS=m
CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y
CONFIG_USB_GSPCA=m
CONFIG_USB_M5602=m
CONFIG_USB_STV06XX=m
CONFIG_USB_GL860=m
CONFIG_USB_GSPCA_BENQ=m
CONFIG_USB_GSPCA_CONEX=m
CONFIG_USB_GSPCA_CPIA1=m
# CONFIG_USB_GSPCA_DTCS033 is not set
CONFIG_USB_GSPCA_ETOMS=m
CONFIG_USB_GSPCA_FINEPIX=m
CONFIG_USB_GSPCA_JEILINJ=m
CONFIG_USB_GSPCA_JL2005BCD=m
# CONFIG_USB_GSPCA_KINECT is not set
CONFIG_USB_GSPCA_KONICA=m
CONFIG_USB_GSPCA_MARS=m
CONFIG_USB_GSPCA_MR97310A=m
CONFIG_USB_GSPCA_NW80X=m
CONFIG_USB_GSPCA_OV519=m
CONFIG_USB_GSPCA_OV534=m
CONFIG_USB_GSPCA_OV534_9=m
CONFIG_USB_GSPCA_PAC207=m
CONFIG_USB_GSPCA_PAC7302=m
CONFIG_USB_GSPCA_PAC7311=m
CONFIG_USB_GSPCA_SE401=m
CONFIG_USB_GSPCA_SN9C2028=m
CONFIG_USB_GSPCA_SN9C20X=m
CONFIG_USB_GSPCA_SONIXB=m
CONFIG_USB_GSPCA_SONIXJ=m
CONFIG_USB_GSPCA_SPCA500=m
CONFIG_USB_GSPCA_SPCA501=m
CONFIG_USB_GSPCA_SPCA505=m
CONFIG_USB_GSPCA_SPCA506=m
CONFIG_USB_GSPCA_SPCA508=m
CONFIG_USB_GSPCA_SPCA561=m
CONFIG_USB_GSPCA_SPCA1528=m
CONFIG_USB_GSPCA_SQ905=m
CONFIG_USB_GSPCA_SQ905C=m
CONFIG_USB_GSPCA_SQ930X=m
CONFIG_USB_GSPCA_STK014=m
# CONFIG_USB_GSPCA_STK1135 is not set
CONFIG_USB_GSPCA_STV0680=m
CONFIG_USB_GSPCA_SUNPLUS=m
CONFIG_USB_GSPCA_T613=m
CONFIG_USB_GSPCA_TOPRO=m
# CONFIG_USB_GSPCA_TOUPTEK is not set
CONFIG_USB_GSPCA_TV8532=m
CONFIG_USB_GSPCA_VC032X=m
CONFIG_USB_GSPCA_VICAM=m
CONFIG_USB_GSPCA_XIRLINK_CIT=m
CONFIG_USB_GSPCA_ZC3XX=m
CONFIG_USB_PWC=m
# CONFIG_USB_PWC_DEBUG is not set
CONFIG_USB_PWC_INPUT_EVDEV=y
# CONFIG_VIDEO_CPIA2 is not set
CONFIG_USB_ZR364XX=m
CONFIG_USB_STKWEBCAM=m
CONFIG_USB_S2255=m
# CONFIG_VIDEO_USBTV is not set

#
# Analog TV USB devices
#
CONFIG_VIDEO_PVRUSB2=m
CONFIG_VIDEO_PVRUSB2_SYSFS=y
CONFIG_VIDEO_PVRUSB2_DVB=y
# CONFIG_VIDEO_PVRUSB2_DEBUGIFC is not set
CONFIG_VIDEO_HDPVR=m
CONFIG_VIDEO_USBVISION=m
# CONFIG_VIDEO_STK1160_COMMON is not set
# CONFIG_VIDEO_GO7007 is not set

#
# Analog/digital TV USB devices
#
CONFIG_VIDEO_AU0828=m
CONFIG_VIDEO_AU0828_V4L2=y
# CONFIG_VIDEO_AU0828_RC is not set
CONFIG_VIDEO_CX231XX=m
CONFIG_VIDEO_CX231XX_RC=y
CONFIG_VIDEO_CX231XX_ALSA=m
CONFIG_VIDEO_CX231XX_DVB=m
CONFIG_VIDEO_TM6000=m
CONFIG_VIDEO_TM6000_ALSA=m
CONFIG_VIDEO_TM6000_DVB=m

#
# Digital TV USB devices
#
CONFIG_DVB_USB=m
# CONFIG_DVB_USB_DEBUG is not set
CONFIG_DVB_USB_DIB3000MC=m
CONFIG_DVB_USB_A800=m
CONFIG_DVB_USB_DIBUSB_MB=m
# CONFIG_DVB_USB_DIBUSB_MB_FAULTY is not set
CONFIG_DVB_USB_DIBUSB_MC=m
CONFIG_DVB_USB_DIB0700=m
CONFIG_DVB_USB_UMT_010=m
CONFIG_DVB_USB_CXUSB=m
# CONFIG_DVB_USB_CXUSB_ANALOG is not set
CONFIG_DVB_USB_M920X=m
CONFIG_DVB_USB_DIGITV=m
CONFIG_DVB_USB_VP7045=m
CONFIG_DVB_USB_VP702X=m
CONFIG_DVB_USB_GP8PSK=m
CONFIG_DVB_USB_NOVA_T_USB2=m
CONFIG_DVB_USB_TTUSB2=m
CONFIG_DVB_USB_DTT200U=m
CONFIG_DVB_USB_OPERA1=m
CONFIG_DVB_USB_AF9005=m
CONFIG_DVB_USB_AF9005_REMOTE=m
CONFIG_DVB_USB_PCTV452E=m
CONFIG_DVB_USB_DW2102=m
CONFIG_DVB_USB_CINERGY_T2=m
CONFIG_DVB_USB_DTV5100=m
CONFIG_DVB_USB_AZ6027=m
CONFIG_DVB_USB_TECHNISAT_USB2=m
CONFIG_DVB_USB_V2=m
CONFIG_DVB_USB_AF9015=m
CONFIG_DVB_USB_AF9035=m
CONFIG_DVB_USB_ANYSEE=m
CONFIG_DVB_USB_AU6610=m
CONFIG_DVB_USB_AZ6007=m
CONFIG_DVB_USB_CE6230=m
CONFIG_DVB_USB_EC168=m
CONFIG_DVB_USB_GL861=m
CONFIG_DVB_USB_LME2510=m
CONFIG_DVB_USB_MXL111SF=m
CONFIG_DVB_USB_RTL28XXU=m
# CONFIG_DVB_USB_DVBSKY is not set
# CONFIG_DVB_USB_ZD1301 is not set
CONFIG_DVB_TTUSB_BUDGET=m
CONFIG_DVB_TTUSB_DEC=m
CONFIG_SMS_USB_DRV=m
CONFIG_DVB_B2C2_FLEXCOP_USB=m
# CONFIG_DVB_B2C2_FLEXCOP_USB_DEBUG is not set
# CONFIG_DVB_AS102 is not set

#
# Webcam, TV (analog/digital) USB devices
#
CONFIG_VIDEO_EM28XX=m
# CONFIG_VIDEO_EM28XX_V4L2 is not set
CONFIG_VIDEO_EM28XX_ALSA=m
CONFIG_VIDEO_EM28XX_DVB=m
CONFIG_VIDEO_EM28XX_RC=m
CONFIG_MEDIA_PCI_SUPPORT=y

#
# Media capture support
#
# CONFIG_VIDEO_MEYE is not set
# CONFIG_VIDEO_SOLO6X10 is not set
# CONFIG_VIDEO_TW5864 is not set
# CONFIG_VIDEO_TW68 is not set
# CONFIG_VIDEO_TW686X is not set

#
# Media capture/analog TV support
#
CONFIG_VIDEO_IVTV=m
# CONFIG_VIDEO_IVTV_DEPRECATED_IOCTLS is not set
# CONFIG_VIDEO_IVTV_ALSA is not set
CONFIG_VIDEO_FB_IVTV=m
# CONFIG_VIDEO_FB_IVTV_FORCE_PAT is not set
# CONFIG_VIDEO_HEXIUM_GEMINI is not set
# CONFIG_VIDEO_HEXIUM_ORION is not set
# CONFIG_VIDEO_MXB is not set
# CONFIG_VIDEO_DT3155 is not set

#
# Media capture/analog/hybrid TV support
#
CONFIG_VIDEO_CX18=m
CONFIG_VIDEO_CX18_ALSA=m
CONFIG_VIDEO_CX23885=m
CONFIG_MEDIA_ALTERA_CI=m
# CONFIG_VIDEO_CX25821 is not set
CONFIG_VIDEO_CX88=m
CONFIG_VIDEO_CX88_ALSA=m
CONFIG_VIDEO_CX88_BLACKBIRD=m
CONFIG_VIDEO_CX88_DVB=m
CONFIG_VIDEO_CX88_ENABLE_VP3054=y
CONFIG_VIDEO_CX88_VP3054=m
CONFIG_VIDEO_CX88_MPEG=m
CONFIG_VIDEO_BT848=m
CONFIG_DVB_BT8XX=m
CONFIG_VIDEO_SAA7134=m
CONFIG_VIDEO_SAA7134_ALSA=m
CONFIG_VIDEO_SAA7134_RC=y
CONFIG_VIDEO_SAA7134_DVB=m
CONFIG_VIDEO_SAA7164=m

#
# Media digital TV PCI Adapters
#
CONFIG_DVB_AV7110_IR=y
CONFIG_DVB_AV7110=m
CONFIG_DVB_AV7110_OSD=y
CONFIG_DVB_BUDGET_CORE=m
CONFIG_DVB_BUDGET=m
CONFIG_DVB_BUDGET_CI=m
CONFIG_DVB_BUDGET_AV=m
CONFIG_DVB_BUDGET_PATCH=m
CONFIG_DVB_B2C2_FLEXCOP_PCI=m
# CONFIG_DVB_B2C2_FLEXCOP_PCI_DEBUG is not set
CONFIG_DVB_PLUTO2=m
CONFIG_DVB_DM1105=m
CONFIG_DVB_PT1=m
# CONFIG_DVB_PT3 is not set
CONFIG_MANTIS_CORE=m
CONFIG_DVB_MANTIS=m
CONFIG_DVB_HOPPER=m
CONFIG_DVB_NGENE=m
CONFIG_DVB_DDBRIDGE=m
# CONFIG_DVB_DDBRIDGE_MSIENABLE is not set
# CONFIG_DVB_SMIPCIE is not set
# CONFIG_DVB_NETUP_UNIDVB is not set
# CONFIG_V4L_PLATFORM_DRIVERS is not set
# CONFIG_V4L_MEM2MEM_DRIVERS is not set
# CONFIG_V4L_TEST_DRIVERS is not set
# CONFIG_DVB_PLATFORM_DRIVERS is not set

#
# Supported MMC/SDIO adapters
#
CONFIG_SMS_SDIO_DRV=m
CONFIG_RADIO_ADAPTERS=y
CONFIG_RADIO_TEA575X=m
# CONFIG_RADIO_SI470X is not set
# CONFIG_RADIO_SI4713 is not set
# CONFIG_USB_MR800 is not set
# CONFIG_USB_DSBR is not set
# CONFIG_RADIO_MAXIRADIO is not set
# CONFIG_RADIO_SHARK is not set
# CONFIG_RADIO_SHARK2 is not set
# CONFIG_USB_KEENE is not set
# CONFIG_USB_RAREMONO is not set
# CONFIG_USB_MA901 is not set
# CONFIG_RADIO_TEA5764 is not set
# CONFIG_RADIO_SAA7706H is not set
# CONFIG_RADIO_TEF6862 is not set
# CONFIG_RADIO_WL1273 is not set

#
# Texas Instruments WL128x FM driver (ST based)
#
# end of Texas Instruments WL128x FM driver (ST based)

#
# Supported FireWire (IEEE 1394) Adapters
#
CONFIG_DVB_FIREDTV=m
CONFIG_DVB_FIREDTV_INPUT=y
CONFIG_MEDIA_COMMON_OPTIONS=y

#
# common driver options
#
CONFIG_VIDEO_CX2341X=m
CONFIG_VIDEO_TVEEPROM=m
CONFIG_CYPRESS_FIRMWARE=m
CONFIG_VIDEOBUF2_CORE=m
CONFIG_VIDEOBUF2_V4L2=m
CONFIG_VIDEOBUF2_MEMOPS=m
CONFIG_VIDEOBUF2_VMALLOC=m
CONFIG_VIDEOBUF2_DMA_SG=m
CONFIG_VIDEOBUF2_DVB=m
CONFIG_DVB_B2C2_FLEXCOP=m
CONFIG_VIDEO_SAA7146=m
CONFIG_VIDEO_SAA7146_VV=m
CONFIG_SMS_SIANO_MDTV=m
CONFIG_SMS_SIANO_RC=y
# CONFIG_SMS_SIANO_DEBUGFS is not set

#
# Media ancillary drivers (tuners, sensors, i2c, spi, frontends)
#
CONFIG_MEDIA_SUBDRV_AUTOSELECT=y
CONFIG_MEDIA_ATTACH=y
CONFIG_VIDEO_IR_I2C=m

#
# I2C Encoders, decoders, sensors and other helper chips
#

#
# Audio decoders, processors and mixers
#
CONFIG_VIDEO_TVAUDIO=m
CONFIG_VIDEO_TDA7432=m
# CONFIG_VIDEO_TDA9840 is not set
# CONFIG_VIDEO_TEA6415C is not set
# CONFIG_VIDEO_TEA6420 is not set
CONFIG_VIDEO_MSP3400=m
CONFIG_VIDEO_CS3308=m
CONFIG_VIDEO_CS5345=m
CONFIG_VIDEO_CS53L32A=m
# CONFIG_VIDEO_TLV320AIC23B is not set
# CONFIG_VIDEO_UDA1342 is not set
CONFIG_VIDEO_WM8775=m
CONFIG_VIDEO_WM8739=m
CONFIG_VIDEO_VP27SMPX=m
# CONFIG_VIDEO_SONY_BTF_MPX is not set

#
# RDS decoders
#
CONFIG_VIDEO_SAA6588=m

#
# Video decoders
#
# CONFIG_VIDEO_ADV7183 is not set
# CONFIG_VIDEO_BT819 is not set
# CONFIG_VIDEO_BT856 is not set
# CONFIG_VIDEO_BT866 is not set
# CONFIG_VIDEO_KS0127 is not set
# CONFIG_VIDEO_ML86V7667 is not set
# CONFIG_VIDEO_SAA7110 is not set
CONFIG_VIDEO_SAA711X=m
# CONFIG_VIDEO_TVP514X is not set
# CONFIG_VIDEO_TVP5150 is not set
# CONFIG_VIDEO_TVP7002 is not set
# CONFIG_VIDEO_TW2804 is not set
# CONFIG_VIDEO_TW9903 is not set
# CONFIG_VIDEO_TW9906 is not set
# CONFIG_VIDEO_TW9910 is not set
# CONFIG_VIDEO_VPX3220 is not set

#
# Video and audio decoders
#
CONFIG_VIDEO_SAA717X=m
CONFIG_VIDEO_CX25840=m

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=m
# CONFIG_VIDEO_SAA7185 is not set
# CONFIG_VIDEO_ADV7170 is not set
# CONFIG_VIDEO_ADV7175 is not set
# CONFIG_VIDEO_ADV7343 is not set
# CONFIG_VIDEO_ADV7393 is not set
# CONFIG_VIDEO_AK881X is not set
# CONFIG_VIDEO_THS8200 is not set

#
# Camera sensor devices
#
# CONFIG_VIDEO_OV2640 is not set
# CONFIG_VIDEO_OV2659 is not set
# CONFIG_VIDEO_OV2680 is not set
# CONFIG_VIDEO_OV2685 is not set
# CONFIG_VIDEO_OV6650 is not set
# CONFIG_VIDEO_OV5695 is not set
# CONFIG_VIDEO_OV772X is not set
# CONFIG_VIDEO_OV7640 is not set
# CONFIG_VIDEO_OV7670 is not set
# CONFIG_VIDEO_OV7740 is not set
# CONFIG_VIDEO_OV9640 is not set
# CONFIG_VIDEO_VS6624 is not set
# CONFIG_VIDEO_MT9M111 is not set
# CONFIG_VIDEO_MT9T112 is not set
# CONFIG_VIDEO_MT9V011 is not set
# CONFIG_VIDEO_MT9V111 is not set
# CONFIG_VIDEO_SR030PC30 is not set
# CONFIG_VIDEO_RJ54N1 is not set

#
# Lens drivers
#
# CONFIG_VIDEO_AD5820 is not set

#
# Flash devices
#
# CONFIG_VIDEO_ADP1653 is not set
# CONFIG_VIDEO_LM3560 is not set
# CONFIG_VIDEO_LM3646 is not set

#
# Video improvement chips
#
CONFIG_VIDEO_UPD64031A=m
CONFIG_VIDEO_UPD64083=m

#
# Audio/Video compression chips
#
CONFIG_VIDEO_SAA6752HS=m

#
# SDR tuner chips
#

#
# Miscellaneous helper chips
#
# CONFIG_VIDEO_THS7303 is not set
CONFIG_VIDEO_M52790=m
# CONFIG_VIDEO_I2C is not set
# end of I2C Encoders, decoders, sensors and other helper chips

#
# SPI helper chips
#
# end of SPI helper chips

#
# Media SPI Adapters
#
# CONFIG_CXD2880_SPI_DRV is not set
# end of Media SPI Adapters

CONFIG_MEDIA_TUNER=m

#
# Customize TV tuners
#
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA18250=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
# CONFIG_MEDIA_TUNER_MSI001 is not set
CONFIG_MEDIA_TUNER_MT20XX=m
CONFIG_MEDIA_TUNER_MT2060=m
CONFIG_MEDIA_TUNER_MT2063=m
CONFIG_MEDIA_TUNER_MT2266=m
CONFIG_MEDIA_TUNER_MT2131=m
CONFIG_MEDIA_TUNER_QT1010=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_MEDIA_TUNER_XC4000=m
CONFIG_MEDIA_TUNER_MXL5005S=m
CONFIG_MEDIA_TUNER_MXL5007T=m
CONFIG_MEDIA_TUNER_MC44S803=m
CONFIG_MEDIA_TUNER_MAX2165=m
CONFIG_MEDIA_TUNER_TDA18218=m
CONFIG_MEDIA_TUNER_FC0011=m
CONFIG_MEDIA_TUNER_FC0012=m
CONFIG_MEDIA_TUNER_FC0013=m
CONFIG_MEDIA_TUNER_TDA18212=m
CONFIG_MEDIA_TUNER_E4000=m
CONFIG_MEDIA_TUNER_FC2580=m
CONFIG_MEDIA_TUNER_M88RS6000T=m
CONFIG_MEDIA_TUNER_TUA9001=m
CONFIG_MEDIA_TUNER_SI2157=m
CONFIG_MEDIA_TUNER_IT913X=m
CONFIG_MEDIA_TUNER_R820T=m
# CONFIG_MEDIA_TUNER_MXL301RF is not set
CONFIG_MEDIA_TUNER_QM1D1C0042=m
CONFIG_MEDIA_TUNER_QM1D1B0004=m
# end of Customize TV tuners

#
# Customise DVB Frontends
#

#
# Multistandard (satellite) frontends
#
CONFIG_DVB_STB0899=m
CONFIG_DVB_STB6100=m
CONFIG_DVB_STV090x=m
CONFIG_DVB_STV0910=m
CONFIG_DVB_STV6110x=m
CONFIG_DVB_STV6111=m
CONFIG_DVB_MXL5XX=m
CONFIG_DVB_M88DS3103=m

#
# Multistandard (cable + terrestrial) frontends
#
CONFIG_DVB_DRXK=m
CONFIG_DVB_TDA18271C2DD=m
CONFIG_DVB_SI2165=m
CONFIG_DVB_MN88472=m
CONFIG_DVB_MN88473=m

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_CX24110=m
CONFIG_DVB_CX24123=m
CONFIG_DVB_MT312=m
CONFIG_DVB_ZL10036=m
CONFIG_DVB_ZL10039=m
CONFIG_DVB_S5H1420=m
CONFIG_DVB_STV0288=m
CONFIG_DVB_STB6000=m
CONFIG_DVB_STV0299=m
CONFIG_DVB_STV6110=m
CONFIG_DVB_STV0900=m
CONFIG_DVB_TDA8083=m
CONFIG_DVB_TDA10086=m
CONFIG_DVB_TDA8261=m
CONFIG_DVB_VES1X93=m
CONFIG_DVB_TUNER_ITD1000=m
CONFIG_DVB_TUNER_CX24113=m
CONFIG_DVB_TDA826X=m
CONFIG_DVB_TUA6100=m
CONFIG_DVB_CX24116=m
CONFIG_DVB_CX24117=m
CONFIG_DVB_CX24120=m
CONFIG_DVB_SI21XX=m
CONFIG_DVB_TS2020=m
CONFIG_DVB_DS3000=m
CONFIG_DVB_MB86A16=m
CONFIG_DVB_TDA10071=m

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_SP8870=m
CONFIG_DVB_SP887X=m
CONFIG_DVB_CX22700=m
CONFIG_DVB_CX22702=m
# CONFIG_DVB_S5H1432 is not set
CONFIG_DVB_DRXD=m
CONFIG_DVB_L64781=m
CONFIG_DVB_TDA1004X=m
CONFIG_DVB_NXT6000=m
CONFIG_DVB_MT352=m
CONFIG_DVB_ZL10353=m
CONFIG_DVB_DIB3000MB=m
CONFIG_DVB_DIB3000MC=m
CONFIG_DVB_DIB7000M=m
CONFIG_DVB_DIB7000P=m
# CONFIG_DVB_DIB9000 is not set
CONFIG_DVB_TDA10048=m
CONFIG_DVB_AF9013=m
CONFIG_DVB_EC100=m
CONFIG_DVB_STV0367=m
CONFIG_DVB_CXD2820R=m
CONFIG_DVB_CXD2841ER=m
CONFIG_DVB_RTL2830=m
CONFIG_DVB_RTL2832=m
CONFIG_DVB_SI2168=m
# CONFIG_DVB_ZD1301_DEMOD is not set
CONFIG_DVB_GP8PSK_FE=m
# CONFIG_DVB_CXD2880 is not set

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=m
CONFIG_DVB_TDA10021=m
CONFIG_DVB_TDA10023=m
CONFIG_DVB_STV0297=m

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=m
CONFIG_DVB_OR51211=m
CONFIG_DVB_OR51132=m
CONFIG_DVB_BCM3510=m
CONFIG_DVB_LGDT330X=m
CONFIG_DVB_LGDT3305=m
CONFIG_DVB_LGDT3306A=m
CONFIG_DVB_LG2160=m
CONFIG_DVB_S5H1409=m
CONFIG_DVB_AU8522=m
CONFIG_DVB_AU8522_DTV=m
CONFIG_DVB_AU8522_V4L=m
CONFIG_DVB_S5H1411=m

#
# ISDB-T (terrestrial) frontends
#
CONFIG_DVB_S921=m
CONFIG_DVB_DIB8000=m
CONFIG_DVB_MB86A20S=m

#
# ISDB-S (satellite) & ISDB-T (terrestrial) frontends
#
CONFIG_DVB_TC90522=m
# CONFIG_DVB_MN88443X is not set

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=m
CONFIG_DVB_TUNER_DIB0070=m
CONFIG_DVB_TUNER_DIB0090=m

#
# SEC control devices for DVB-S
#
CONFIG_DVB_DRX39XYJ=m
CONFIG_DVB_LNBH25=m
# CONFIG_DVB_LNBH29 is not set
CONFIG_DVB_LNBP21=m
CONFIG_DVB_LNBP22=m
CONFIG_DVB_ISL6405=m
CONFIG_DVB_ISL6421=m
CONFIG_DVB_ISL6423=m
CONFIG_DVB_A8293=m
# CONFIG_DVB_LGS8GL5 is not set
CONFIG_DVB_LGS8GXX=m
CONFIG_DVB_ATBM8830=m
CONFIG_DVB_TDA665x=m
CONFIG_DVB_IX2505V=m
CONFIG_DVB_M88RS2000=m
CONFIG_DVB_AF9033=m
# CONFIG_DVB_HORUS3A is not set
# CONFIG_DVB_ASCOT2E is not set
# CONFIG_DVB_HELENE is not set

#
# Common Interface (EN50221) controller drivers
#
CONFIG_DVB_CXD2099=m
# CONFIG_DVB_SP2 is not set

#
# Tools to develop new frontends
#
CONFIG_DVB_DUMMY_FE=m
# end of Customise DVB Frontends

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
CONFIG_AGP_SIS=y
CONFIG_AGP_VIA=y
CONFIG_INTEL_GTT=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=64
CONFIG_VGA_SWITCHEROO=y
CONFIG_DRM=m
CONFIG_DRM_MIPI_DSI=y
CONFIG_DRM_DP_AUX_CHARDEV=y
CONFIG_DRM_EXPORT_FOR_TESTS=y
CONFIG_DRM_DEBUG_SELFTEST=m
CONFIG_DRM_KMS_HELPER=m
CONFIG_DRM_KMS_FB_HELPER=y
# CONFIG_DRM_DEBUG_DP_MST_TOPOLOGY_REFS is not set
CONFIG_DRM_FBDEV_EMULATION=y
CONFIG_DRM_FBDEV_OVERALLOC=100
# CONFIG_DRM_FBDEV_LEAK_PHYS_SMEM is not set
CONFIG_DRM_LOAD_EDID_FIRMWARE=y
# CONFIG_DRM_DP_CEC is not set
CONFIG_DRM_TTM=m
CONFIG_DRM_TTM_DMA_PAGE_POOL=y
CONFIG_DRM_VRAM_HELPER=m
CONFIG_DRM_TTM_HELPER=m
CONFIG_DRM_GEM_SHMEM_HELPER=y

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=m
CONFIG_DRM_I2C_SIL164=m
# CONFIG_DRM_I2C_NXP_TDA998X is not set
# CONFIG_DRM_I2C_NXP_TDA9950 is not set
# end of I2C encoder or helper chips

#
# ARM devices
#
# end of ARM devices

# CONFIG_DRM_RADEON is not set
# CONFIG_DRM_AMDGPU is not set

#
# ACP (Audio CoProcessor) Configuration
#
# end of ACP (Audio CoProcessor) Configuration

# CONFIG_DRM_NOUVEAU is not set
CONFIG_DRM_I915=m
# CONFIG_DRM_I915_ALPHA_SUPPORT is not set
CONFIG_DRM_I915_FORCE_PROBE=""
CONFIG_DRM_I915_CAPTURE_ERROR=y
CONFIG_DRM_I915_COMPRESS_ERROR=y
CONFIG_DRM_I915_USERPTR=y
CONFIG_DRM_I915_GVT=y
CONFIG_DRM_I915_GVT_KVMGT=m

#
# drm/i915 Debugging
#
# CONFIG_DRM_I915_WERROR is not set
# CONFIG_DRM_I915_DEBUG is not set
# CONFIG_DRM_I915_DEBUG_MMIO is not set
# CONFIG_DRM_I915_SW_FENCE_DEBUG_OBJECTS is not set
# CONFIG_DRM_I915_SW_FENCE_CHECK_DAG is not set
# CONFIG_DRM_I915_DEBUG_GUC is not set
# CONFIG_DRM_I915_SELFTEST is not set
# CONFIG_DRM_I915_LOW_LEVEL_TRACEPOINTS is not set
# CONFIG_DRM_I915_DEBUG_VBLANK_EVADE is not set
# CONFIG_DRM_I915_DEBUG_RUNTIME_PM is not set
# end of drm/i915 Debugging

#
# drm/i915 Profile Guided Optimisation
#
CONFIG_DRM_I915_USERFAULT_AUTOSUSPEND=250
CONFIG_DRM_I915_HEARTBEAT_INTERVAL=2500
CONFIG_DRM_I915_PREEMPT_TIMEOUT=640
CONFIG_DRM_I915_SPIN_REQUEST=5
CONFIG_DRM_I915_STOP_TIMEOUT=100
CONFIG_DRM_I915_TIMESLICE_DURATION=1
# end of drm/i915 Profile Guided Optimisation

CONFIG_DRM_VGEM=m
# CONFIG_DRM_VKMS is not set
CONFIG_DRM_VMWGFX=m
CONFIG_DRM_VMWGFX_FBCON=y
CONFIG_DRM_GMA500=m
CONFIG_DRM_GMA600=y
CONFIG_DRM_GMA3600=y
CONFIG_DRM_UDL=m
CONFIG_DRM_AST=m
CONFIG_DRM_MGAG200=m
CONFIG_DRM_CIRRUS_QEMU=m
CONFIG_DRM_QXL=m
CONFIG_DRM_BOCHS=m
CONFIG_DRM_VIRTIO_GPU=m
CONFIG_DRM_PANEL=y

#
# Display Panels
#
# CONFIG_DRM_PANEL_RASPBERRYPI_TOUCHSCREEN is not set
# end of Display Panels

CONFIG_DRM_BRIDGE=y
CONFIG_DRM_PANEL_BRIDGE=y

#
# Display Interface Bridges
#
# CONFIG_DRM_ANALOGIX_ANX78XX is not set
# end of Display Interface Bridges

# CONFIG_DRM_ETNAVIV is not set
# CONFIG_DRM_GM12U320 is not set
# CONFIG_TINYDRM_HX8357D is not set
# CONFIG_TINYDRM_ILI9225 is not set
# CONFIG_TINYDRM_ILI9341 is not set
# CONFIG_TINYDRM_MI0283QT is not set
# CONFIG_TINYDRM_REPAPER is not set
# CONFIG_TINYDRM_ST7586 is not set
# CONFIG_TINYDRM_ST7735R is not set
# CONFIG_DRM_XEN is not set
# CONFIG_DRM_VBOXVIDEO is not set
# CONFIG_DRM_LEGACY is not set
CONFIG_DRM_PANEL_ORIENTATION_QUIRKS=y
CONFIG_DRM_LIB_RANDOM=y

#
# Frame buffer Devices
#
CONFIG_FB_CMDLINE=y
CONFIG_FB_NOTIFY=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_BOOT_VESA_SUPPORT=y
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=m
CONFIG_FB_DEFERRED_IO=y
# CONFIG_FB_MODE_HELPERS is not set
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
CONFIG_FB_VESA=y
CONFIG_FB_EFI=y
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_OPENCORES is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_I740 is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_INTEL is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_SM501 is not set
# CONFIG_FB_SMSCUFX is not set
# CONFIG_FB_UDL is not set
# CONFIG_FB_IBM_GXT4500 is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_XEN_FBDEV_FRONTEND is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
CONFIG_FB_HYPERV=m
# CONFIG_FB_SIMPLE is not set
# CONFIG_FB_SM712 is not set
# end of Frame buffer Devices

#
# Backlight & LCD device support
#
CONFIG_LCD_CLASS_DEVICE=m
# CONFIG_LCD_L4F00242T03 is not set
# CONFIG_LCD_LMS283GF05 is not set
# CONFIG_LCD_LTV350QV is not set
# CONFIG_LCD_ILI922X is not set
# CONFIG_LCD_ILI9320 is not set
# CONFIG_LCD_TDO24M is not set
# CONFIG_LCD_VGG2432A4 is not set
CONFIG_LCD_PLATFORM=m
# CONFIG_LCD_AMS369FG06 is not set
# CONFIG_LCD_LMS501KF03 is not set
# CONFIG_LCD_HX8357 is not set
# CONFIG_LCD_OTM3225A is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
# CONFIG_BACKLIGHT_PWM is not set
CONFIG_BACKLIGHT_APPLE=m
# CONFIG_BACKLIGHT_QCOM_WLED is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
# CONFIG_BACKLIGHT_LM3630A is not set
# CONFIG_BACKLIGHT_LM3639 is not set
CONFIG_BACKLIGHT_LP855X=m
# CONFIG_BACKLIGHT_GPIO is not set
# CONFIG_BACKLIGHT_LV5207LP is not set
# CONFIG_BACKLIGHT_BD6107 is not set
# CONFIG_BACKLIGHT_ARCXCNN is not set
# end of Backlight & LCD device support

CONFIG_HDMI=y

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
# CONFIG_VGACON_SOFT_SCROLLBACK_PERSISTENT_ENABLE_BY_DEFAULT is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_DUMMY_CONSOLE_COLUMNS=80
CONFIG_DUMMY_CONSOLE_ROWS=25
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
# CONFIG_FRAMEBUFFER_CONSOLE_DEFERRED_TAKEOVER is not set
# end of Console display driver support

CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
# end of Graphics support

CONFIG_SOUND=m
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_PCM_ELD=y
CONFIG_SND_HWDEP=m
CONFIG_SND_SEQ_DEVICE=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_COMPRESS_OFFLOAD=m
CONFIG_SND_JACK=y
CONFIG_SND_JACK_INPUT_DEV=y
CONFIG_SND_OSSEMUL=y
# CONFIG_SND_MIXER_OSS is not set
# CONFIG_SND_PCM_OSS is not set
CONFIG_SND_PCM_TIMER=y
CONFIG_SND_HRTIMER=m
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_MAX_CARDS=32
# CONFIG_SND_SUPPORT_OLD_API is not set
CONFIG_SND_PROC_FS=y
CONFIG_SND_VERBOSE_PROCFS=y
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_SEQUENCER_OSS=m
CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
CONFIG_SND_SEQ_MIDI_EVENT=m
CONFIG_SND_SEQ_MIDI=m
CONFIG_SND_SEQ_MIDI_EMUL=m
CONFIG_SND_SEQ_VIRMIDI=m
CONFIG_SND_MPU401_UART=m
CONFIG_SND_OPL3_LIB=m
CONFIG_SND_OPL3_LIB_SEQ=m
CONFIG_SND_VX_LIB=m
CONFIG_SND_AC97_CODEC=m
CONFIG_SND_DRIVERS=y
CONFIG_SND_PCSP=m
CONFIG_SND_DUMMY=m
CONFIG_SND_ALOOP=m
CONFIG_SND_VIRMIDI=m
CONFIG_SND_MTPAV=m
# CONFIG_SND_MTS64 is not set
# CONFIG_SND_SERIAL_U16550 is not set
CONFIG_SND_MPU401=m
# CONFIG_SND_PORTMAN2X4 is not set
CONFIG_SND_AC97_POWER_SAVE=y
CONFIG_SND_AC97_POWER_SAVE_DEFAULT=5
CONFIG_SND_PCI=y
CONFIG_SND_AD1889=m
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
CONFIG_SND_ALI5451=m
CONFIG_SND_ASIHPI=m
CONFIG_SND_ATIIXP=m
CONFIG_SND_ATIIXP_MODEM=m
CONFIG_SND_AU8810=m
CONFIG_SND_AU8820=m
CONFIG_SND_AU8830=m
# CONFIG_SND_AW2 is not set
# CONFIG_SND_AZT3328 is not set
CONFIG_SND_BT87X=m
# CONFIG_SND_BT87X_OVERCLOCK is not set
CONFIG_SND_CA0106=m
CONFIG_SND_CMIPCI=m
CONFIG_SND_OXYGEN_LIB=m
CONFIG_SND_OXYGEN=m
# CONFIG_SND_CS4281 is not set
CONFIG_SND_CS46XX=m
CONFIG_SND_CS46XX_NEW_DSP=y
CONFIG_SND_CTXFI=m
CONFIG_SND_DARLA20=m
CONFIG_SND_GINA20=m
CONFIG_SND_LAYLA20=m
CONFIG_SND_DARLA24=m
CONFIG_SND_GINA24=m
CONFIG_SND_LAYLA24=m
CONFIG_SND_MONA=m
CONFIG_SND_MIA=m
CONFIG_SND_ECHO3G=m
CONFIG_SND_INDIGO=m
CONFIG_SND_INDIGOIO=m
CONFIG_SND_INDIGODJ=m
CONFIG_SND_INDIGOIOX=m
CONFIG_SND_INDIGODJX=m
CONFIG_SND_EMU10K1=m
CONFIG_SND_EMU10K1_SEQ=m
CONFIG_SND_EMU10K1X=m
CONFIG_SND_ENS1370=m
CONFIG_SND_ENS1371=m
# CONFIG_SND_ES1938 is not set
CONFIG_SND_ES1968=m
CONFIG_SND_ES1968_INPUT=y
CONFIG_SND_ES1968_RADIO=y
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDSP=m
CONFIG_SND_HDSPM=m
CONFIG_SND_ICE1712=m
CONFIG_SND_ICE1724=m
CONFIG_SND_INTEL8X0=m
CONFIG_SND_INTEL8X0M=m
CONFIG_SND_KORG1212=m
CONFIG_SND_LOLA=m
CONFIG_SND_LX6464ES=m
CONFIG_SND_MAESTRO3=m
CONFIG_SND_MAESTRO3_INPUT=y
CONFIG_SND_MIXART=m
# CONFIG_SND_NM256 is not set
CONFIG_SND_PCXHR=m
# CONFIG_SND_RIPTIDE is not set
CONFIG_SND_RME32=m
CONFIG_SND_RME96=m
CONFIG_SND_RME9652=m
# CONFIG_SND_SONICVIBES is not set
CONFIG_SND_TRIDENT=m
CONFIG_SND_VIA82XX=m
CONFIG_SND_VIA82XX_MODEM=m
CONFIG_SND_VIRTUOSO=m
CONFIG_SND_VX222=m
# CONFIG_SND_YMFPCI is not set

#
# HD-Audio
#
CONFIG_SND_HDA=m
CONFIG_SND_HDA_INTEL=m
CONFIG_SND_HDA_HWDEP=y
CONFIG_SND_HDA_RECONFIG=y
CONFIG_SND_HDA_INPUT_BEEP=y
CONFIG_SND_HDA_INPUT_BEEP_MODE=0
CONFIG_SND_HDA_PATCH_LOADER=y
CONFIG_SND_HDA_CODEC_REALTEK=m
CONFIG_SND_HDA_CODEC_ANALOG=m
CONFIG_SND_HDA_CODEC_SIGMATEL=m
CONFIG_SND_HDA_CODEC_VIA=m
CONFIG_SND_HDA_CODEC_HDMI=m
CONFIG_SND_HDA_CODEC_CIRRUS=m
CONFIG_SND_HDA_CODEC_CONEXANT=m
CONFIG_SND_HDA_CODEC_CA0110=m
CONFIG_SND_HDA_CODEC_CA0132=m
CONFIG_SND_HDA_CODEC_CA0132_DSP=y
CONFIG_SND_HDA_CODEC_CMEDIA=m
CONFIG_SND_HDA_CODEC_SI3054=m
CONFIG_SND_HDA_GENERIC=m
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=0
# end of HD-Audio

CONFIG_SND_HDA_CORE=m
CONFIG_SND_HDA_DSP_LOADER=y
CONFIG_SND_HDA_COMPONENT=y
CONFIG_SND_HDA_I915=y
CONFIG_SND_HDA_EXT_CORE=m
CONFIG_SND_HDA_PREALLOC_SIZE=0
CONFIG_SND_INTEL_NHLT=y
CONFIG_SND_INTEL_DSP_CONFIG=m
# CONFIG_SND_SPI is not set
CONFIG_SND_USB=y
CONFIG_SND_USB_AUDIO=m
CONFIG_SND_USB_AUDIO_USE_MEDIA_CONTROLLER=y
CONFIG_SND_USB_UA101=m
CONFIG_SND_USB_USX2Y=m
CONFIG_SND_USB_CAIAQ=m
CONFIG_SND_USB_CAIAQ_INPUT=y
CONFIG_SND_USB_US122L=m
CONFIG_SND_USB_6FIRE=m
CONFIG_SND_USB_HIFACE=m
CONFIG_SND_BCD2000=m
CONFIG_SND_USB_LINE6=m
CONFIG_SND_USB_POD=m
CONFIG_SND_USB_PODHD=m
CONFIG_SND_USB_TONEPORT=m
CONFIG_SND_USB_VARIAX=m
CONFIG_SND_FIREWIRE=y
CONFIG_SND_FIREWIRE_LIB=m
# CONFIG_SND_DICE is not set
# CONFIG_SND_OXFW is not set
CONFIG_SND_ISIGHT=m
# CONFIG_SND_FIREWORKS is not set
# CONFIG_SND_BEBOB is not set
# CONFIG_SND_FIREWIRE_DIGI00X is not set
# CONFIG_SND_FIREWIRE_TASCAM is not set
# CONFIG_SND_FIREWIRE_MOTU is not set
# CONFIG_SND_FIREFACE is not set
CONFIG_SND_SOC=m
CONFIG_SND_SOC_COMPRESS=y
CONFIG_SND_SOC_TOPOLOGY=y
CONFIG_SND_SOC_ACPI=m
# CONFIG_SND_SOC_AMD_ACP is not set
# CONFIG_SND_SOC_AMD_ACP3x is not set
# CONFIG_SND_ATMEL_SOC is not set
# CONFIG_SND_DESIGNWARE_I2S is not set

#
# SoC Audio for Freescale CPUs
#

#
# Common SoC Audio options for Freescale CPUs:
#
# CONFIG_SND_SOC_FSL_ASRC is not set
# CONFIG_SND_SOC_FSL_SAI is not set
# CONFIG_SND_SOC_FSL_AUDMIX is not set
# CONFIG_SND_SOC_FSL_SSI is not set
# CONFIG_SND_SOC_FSL_SPDIF is not set
# CONFIG_SND_SOC_FSL_ESAI is not set
# CONFIG_SND_SOC_FSL_MICFIL is not set
# CONFIG_SND_SOC_IMX_AUDMUX is not set
# end of SoC Audio for Freescale CPUs

# CONFIG_SND_I2S_HI6210_I2S is not set
# CONFIG_SND_SOC_IMG is not set
CONFIG_SND_SOC_INTEL_SST_TOPLEVEL=y
CONFIG_SND_SST_IPC=m
CONFIG_SND_SST_IPC_ACPI=m
CONFIG_SND_SOC_INTEL_SST_ACPI=m
CONFIG_SND_SOC_INTEL_SST=m
CONFIG_SND_SOC_INTEL_SST_FIRMWARE=m
CONFIG_SND_SOC_INTEL_HASWELL=m
CONFIG_SND_SST_ATOM_HIFI2_PLATFORM=m
# CONFIG_SND_SST_ATOM_HIFI2_PLATFORM_PCI is not set
CONFIG_SND_SST_ATOM_HIFI2_PLATFORM_ACPI=m
CONFIG_SND_SOC_INTEL_SKYLAKE=m
CONFIG_SND_SOC_INTEL_SKL=m
CONFIG_SND_SOC_INTEL_APL=m
CONFIG_SND_SOC_INTEL_KBL=m
CONFIG_SND_SOC_INTEL_GLK=m
CONFIG_SND_SOC_INTEL_CNL=m
CONFIG_SND_SOC_INTEL_CFL=m
# CONFIG_SND_SOC_INTEL_CML_H is not set
# CONFIG_SND_SOC_INTEL_CML_LP is not set
CONFIG_SND_SOC_INTEL_SKYLAKE_FAMILY=m
CONFIG_SND_SOC_INTEL_SKYLAKE_SSP_CLK=m
# CONFIG_SND_SOC_INTEL_SKYLAKE_HDAUDIO_CODEC is not set
CONFIG_SND_SOC_INTEL_SKYLAKE_COMMON=m
CONFIG_SND_SOC_ACPI_INTEL_MATCH=m
CONFIG_SND_SOC_INTEL_MACH=y
# CONFIG_SND_SOC_INTEL_USER_FRIENDLY_LONG_NAMES is not set
CONFIG_SND_SOC_INTEL_HASWELL_MACH=m
# CONFIG_SND_SOC_INTEL_BDW_RT5650_MACH is not set
CONFIG_SND_SOC_INTEL_BDW_RT5677_MACH=m
CONFIG_SND_SOC_INTEL_BROADWELL_MACH=m
CONFIG_SND_SOC_INTEL_BYTCR_RT5640_MACH=m
CONFIG_SND_SOC_INTEL_BYTCR_RT5651_MACH=m
CONFIG_SND_SOC_INTEL_CHT_BSW_RT5672_MACH=m
CONFIG_SND_SOC_INTEL_CHT_BSW_RT5645_MACH=m
CONFIG_SND_SOC_INTEL_CHT_BSW_MAX98090_TI_MACH=m
# CONFIG_SND_SOC_INTEL_CHT_BSW_NAU8824_MACH is not set
# CONFIG_SND_SOC_INTEL_BYT_CHT_CX2072X_MACH is not set
CONFIG_SND_SOC_INTEL_BYT_CHT_DA7213_MACH=m
CONFIG_SND_SOC_INTEL_BYT_CHT_ES8316_MACH=m
CONFIG_SND_SOC_INTEL_BYT_CHT_NOCODEC_MACH=m
CONFIG_SND_SOC_INTEL_SKL_RT286_MACH=m
CONFIG_SND_SOC_INTEL_SKL_NAU88L25_SSM4567_MACH=m
CONFIG_SND_SOC_INTEL_SKL_NAU88L25_MAX98357A_MACH=m
CONFIG_SND_SOC_INTEL_DA7219_MAX98357A_GENERIC=m
CONFIG_SND_SOC_INTEL_BXT_DA7219_MAX98357A_COMMON=m
CONFIG_SND_SOC_INTEL_BXT_DA7219_MAX98357A_MACH=m
CONFIG_SND_SOC_INTEL_BXT_RT298_MACH=m
CONFIG_SND_SOC_INTEL_KBL_RT5663_MAX98927_MACH=m
CONFIG_SND_SOC_INTEL_KBL_RT5663_RT5514_MAX98927_MACH=m
# CONFIG_SND_SOC_INTEL_KBL_DA7219_MAX98357A_MACH is not set
# CONFIG_SND_SOC_INTEL_KBL_DA7219_MAX98927_MACH is not set
# CONFIG_SND_SOC_INTEL_KBL_RT5660_MACH is not set
# CONFIG_SND_SOC_MTK_BTCVSD is not set
# CONFIG_SND_SOC_SOF_TOPLEVEL is not set

#
# STMicroelectronics STM32 SOC audio support
#
# end of STMicroelectronics STM32 SOC audio support

# CONFIG_SND_SOC_XILINX_I2S is not set
# CONFIG_SND_SOC_XILINX_AUDIO_FORMATTER is not set
# CONFIG_SND_SOC_XILINX_SPDIF is not set
# CONFIG_SND_SOC_XTFPGA_I2S is not set
# CONFIG_ZX_TDM is not set
CONFIG_SND_SOC_I2C_AND_SPI=m

#
# CODEC drivers
#
# CONFIG_SND_SOC_AC97_CODEC is not set
# CONFIG_SND_SOC_ADAU1701 is not set
# CONFIG_SND_SOC_ADAU1761_I2C is not set
# CONFIG_SND_SOC_ADAU1761_SPI is not set
# CONFIG_SND_SOC_ADAU7002 is not set
# CONFIG_SND_SOC_ADAU7118_HW is not set
# CONFIG_SND_SOC_ADAU7118_I2C is not set
# CONFIG_SND_SOC_AK4104 is not set
# CONFIG_SND_SOC_AK4118 is not set
# CONFIG_SND_SOC_AK4458 is not set
# CONFIG_SND_SOC_AK4554 is not set
# CONFIG_SND_SOC_AK4613 is not set
# CONFIG_SND_SOC_AK4642 is not set
# CONFIG_SND_SOC_AK5386 is not set
# CONFIG_SND_SOC_AK5558 is not set
# CONFIG_SND_SOC_ALC5623 is not set
# CONFIG_SND_SOC_BD28623 is not set
# CONFIG_SND_SOC_BT_SCO is not set
# CONFIG_SND_SOC_CS35L32 is not set
# CONFIG_SND_SOC_CS35L33 is not set
# CONFIG_SND_SOC_CS35L34 is not set
# CONFIG_SND_SOC_CS35L35 is not set
# CONFIG_SND_SOC_CS35L36 is not set
# CONFIG_SND_SOC_CS42L42 is not set
# CONFIG_SND_SOC_CS42L51_I2C is not set
# CONFIG_SND_SOC_CS42L52 is not set
# CONFIG_SND_SOC_CS42L56 is not set
# CONFIG_SND_SOC_CS42L73 is not set
# CONFIG_SND_SOC_CS4265 is not set
# CONFIG_SND_SOC_CS4270 is not set
# CONFIG_SND_SOC_CS4271_I2C is not set
# CONFIG_SND_SOC_CS4271_SPI is not set
# CONFIG_SND_SOC_CS42XX8_I2C is not set
# CONFIG_SND_SOC_CS43130 is not set
# CONFIG_SND_SOC_CS4341 is not set
# CONFIG_SND_SOC_CS4349 is not set
# CONFIG_SND_SOC_CS53L30 is not set
# CONFIG_SND_SOC_CX2072X is not set
CONFIG_SND_SOC_DA7213=m
CONFIG_SND_SOC_DA7219=m
CONFIG_SND_SOC_DMIC=m
# CONFIG_SND_SOC_ES7134 is not set
# CONFIG_SND_SOC_ES7241 is not set
CONFIG_SND_SOC_ES8316=m
# CONFIG_SND_SOC_ES8328_I2C is not set
# CONFIG_SND_SOC_ES8328_SPI is not set
# CONFIG_SND_SOC_GTM601 is not set
CONFIG_SND_SOC_HDAC_HDMI=m
# CONFIG_SND_SOC_INNO_RK3036 is not set
# CONFIG_SND_SOC_MAX98088 is not set
CONFIG_SND_SOC_MAX98090=m
CONFIG_SND_SOC_MAX98357A=m
# CONFIG_SND_SOC_MAX98504 is not set
# CONFIG_SND_SOC_MAX9867 is not set
CONFIG_SND_SOC_MAX98927=m
# CONFIG_SND_SOC_MAX98373 is not set
# CONFIG_SND_SOC_MAX9860 is not set
# CONFIG_SND_SOC_MSM8916_WCD_DIGITAL is not set
# CONFIG_SND_SOC_PCM1681 is not set
# CONFIG_SND_SOC_PCM1789_I2C is not set
# CONFIG_SND_SOC_PCM179X_I2C is not set
# CONFIG_SND_SOC_PCM179X_SPI is not set
# CONFIG_SND_SOC_PCM186X_I2C is not set
# CONFIG_SND_SOC_PCM186X_SPI is not set
# CONFIG_SND_SOC_PCM3060_I2C is not set
# CONFIG_SND_SOC_PCM3060_SPI is not set
# CONFIG_SND_SOC_PCM3168A_I2C is not set
# CONFIG_SND_SOC_PCM3168A_SPI is not set
# CONFIG_SND_SOC_PCM512x_I2C is not set
# CONFIG_SND_SOC_PCM512x_SPI is not set
# CONFIG_SND_SOC_RK3328 is not set
CONFIG_SND_SOC_RL6231=m
CONFIG_SND_SOC_RL6347A=m
CONFIG_SND_SOC_RT286=m
CONFIG_SND_SOC_RT298=m
CONFIG_SND_SOC_RT5514=m
CONFIG_SND_SOC_RT5514_SPI=m
# CONFIG_SND_SOC_RT5616 is not set
# CONFIG_SND_SOC_RT5631 is not set
CONFIG_SND_SOC_RT5640=m
CONFIG_SND_SOC_RT5645=m
CONFIG_SND_SOC_RT5651=m
CONFIG_SND_SOC_RT5663=m
CONFIG_SND_SOC_RT5670=m
CONFIG_SND_SOC_RT5677=m
CONFIG_SND_SOC_RT5677_SPI=m
# CONFIG_SND_SOC_SGTL5000 is not set
# CONFIG_SND_SOC_SIMPLE_AMPLIFIER is not set
# CONFIG_SND_SOC_SIRF_AUDIO_CODEC is not set
# CONFIG_SND_SOC_SPDIF is not set
# CONFIG_SND_SOC_SSM2305 is not set
# CONFIG_SND_SOC_SSM2602_SPI is not set
# CONFIG_SND_SOC_SSM2602_I2C is not set
CONFIG_SND_SOC_SSM4567=m
# CONFIG_SND_SOC_STA32X is not set
# CONFIG_SND_SOC_STA350 is not set
# CONFIG_SND_SOC_STI_SAS is not set
# CONFIG_SND_SOC_TAS2552 is not set
# CONFIG_SND_SOC_TAS2562 is not set
# CONFIG_SND_SOC_TAS2770 is not set
# CONFIG_SND_SOC_TAS5086 is not set
# CONFIG_SND_SOC_TAS571X is not set
# CONFIG_SND_SOC_TAS5720 is not set
# CONFIG_SND_SOC_TAS6424 is not set
# CONFIG_SND_SOC_TDA7419 is not set
# CONFIG_SND_SOC_TFA9879 is not set
# CONFIG_SND_SOC_TLV320AIC23_I2C is not set
# CONFIG_SND_SOC_TLV320AIC23_SPI is not set
# CONFIG_SND_SOC_TLV320AIC31XX is not set
# CONFIG_SND_SOC_TLV320AIC32X4_I2C is not set
# CONFIG_SND_SOC_TLV320AIC32X4_SPI is not set
# CONFIG_SND_SOC_TLV320AIC3X is not set
CONFIG_SND_SOC_TS3A227E=m
# CONFIG_SND_SOC_TSCS42XX is not set
# CONFIG_SND_SOC_TSCS454 is not set
# CONFIG_SND_SOC_UDA1334 is not set
# CONFIG_SND_SOC_WM8510 is not set
# CONFIG_SND_SOC_WM8523 is not set
# CONFIG_SND_SOC_WM8524 is not set
# CONFIG_SND_SOC_WM8580 is not set
# CONFIG_SND_SOC_WM8711 is not set
# CONFIG_SND_SOC_WM8728 is not set
# CONFIG_SND_SOC_WM8731 is not set
# CONFIG_SND_SOC_WM8737 is not set
# CONFIG_SND_SOC_WM8741 is not set
# CONFIG_SND_SOC_WM8750 is not set
# CONFIG_SND_SOC_WM8753 is not set
# CONFIG_SND_SOC_WM8770 is not set
# CONFIG_SND_SOC_WM8776 is not set
# CONFIG_SND_SOC_WM8782 is not set
# CONFIG_SND_SOC_WM8804_I2C is not set
# CONFIG_SND_SOC_WM8804_SPI is not set
# CONFIG_SND_SOC_WM8903 is not set
# CONFIG_SND_SOC_WM8904 is not set
# CONFIG_SND_SOC_WM8960 is not set
# CONFIG_SND_SOC_WM8962 is not set
# CONFIG_SND_SOC_WM8974 is not set
# CONFIG_SND_SOC_WM8978 is not set
# CONFIG_SND_SOC_WM8985 is not set
# CONFIG_SND_SOC_ZX_AUD96P22 is not set
# CONFIG_SND_SOC_MAX9759 is not set
# CONFIG_SND_SOC_MT6351 is not set
# CONFIG_SND_SOC_MT6358 is not set
# CONFIG_SND_SOC_MT6660 is not set
# CONFIG_SND_SOC_NAU8540 is not set
# CONFIG_SND_SOC_NAU8810 is not set
# CONFIG_SND_SOC_NAU8822 is not set
CONFIG_SND_SOC_NAU8824=m
CONFIG_SND_SOC_NAU8825=m
# CONFIG_SND_SOC_TPA6130A2 is not set
# end of CODEC drivers

# CONFIG_SND_SIMPLE_CARD is not set
CONFIG_SND_X86=y
CONFIG_HDMI_LPE_AUDIO=m
CONFIG_SND_SYNTH_EMUX=m
# CONFIG_SND_XEN_FRONTEND is not set
CONFIG_AC97_BUS=m

#
# HID support
#
CONFIG_HID=y
CONFIG_HID_BATTERY_STRENGTH=y
CONFIG_HIDRAW=y
CONFIG_UHID=m
CONFIG_HID_GENERIC=y

#
# Special HID drivers
#
CONFIG_HID_A4TECH=y
# CONFIG_HID_ACCUTOUCH is not set
CONFIG_HID_ACRUX=m
# CONFIG_HID_ACRUX_FF is not set
CONFIG_HID_APPLE=y
CONFIG_HID_APPLEIR=m
# CONFIG_HID_ASUS is not set
CONFIG_HID_AUREAL=m
CONFIG_HID_BELKIN=y
# CONFIG_HID_BETOP_FF is not set
# CONFIG_HID_BIGBEN_FF is not set
CONFIG_HID_CHERRY=y
CONFIG_HID_CHICONY=y
# CONFIG_HID_CORSAIR is not set
# CONFIG_HID_COUGAR is not set
# CONFIG_HID_MACALLY is not set
CONFIG_HID_PRODIKEYS=m
# CONFIG_HID_CMEDIA is not set
# CONFIG_HID_CP2112 is not set
# CONFIG_HID_CREATIVE_SB0540 is not set
CONFIG_HID_CYPRESS=y
CONFIG_HID_DRAGONRISE=m
# CONFIG_DRAGONRISE_FF is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_ELAN is not set
CONFIG_HID_ELECOM=m
# CONFIG_HID_ELO is not set
CONFIG_HID_EZKEY=y
# CONFIG_HID_GEMBIRD is not set
# CONFIG_HID_GFRM is not set
CONFIG_HID_HOLTEK=m
# CONFIG_HOLTEK_FF is not set
# CONFIG_HID_GT683R is not set
CONFIG_HID_KEYTOUCH=m
CONFIG_HID_KYE=m
CONFIG_HID_UCLOGIC=m
CONFIG_HID_WALTOP=m
# CONFIG_HID_VIEWSONIC is not set
CONFIG_HID_GYRATION=m
CONFIG_HID_ICADE=m
CONFIG_HID_ITE=y
# CONFIG_HID_JABRA is not set
CONFIG_HID_TWINHAN=m
CONFIG_HID_KENSINGTON=y
CONFIG_HID_LCPOWER=m
CONFIG_HID_LED=m
# CONFIG_HID_LENOVO is not set
CONFIG_HID_LOGITECH=y
CONFIG_HID_LOGITECH_DJ=m
CONFIG_HID_LOGITECH_HIDPP=m
# CONFIG_LOGITECH_FF is not set
# CONFIG_LOGIRUMBLEPAD2_FF is not set
# CONFIG_LOGIG940_FF is not set
# CONFIG_LOGIWHEELS_FF is not set
CONFIG_HID_MAGICMOUSE=y
# CONFIG_HID_MALTRON is not set
# CONFIG_HID_MAYFLASH is not set
CONFIG_HID_REDRAGON=y
CONFIG_HID_MICROSOFT=y
CONFIG_HID_MONTEREY=y
CONFIG_HID_MULTITOUCH=m
# CONFIG_HID_NTI is not set
CONFIG_HID_NTRIG=y
CONFIG_HID_ORTEK=m
CONFIG_HID_PANTHERLORD=m
# CONFIG_PANTHERLORD_FF is not set
# CONFIG_HID_PENMOUNT is not set
CONFIG_HID_PETALYNX=m
CONFIG_HID_PICOLCD=m
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LCD=y
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PICOLCD_CIR=y
CONFIG_HID_PLANTRONICS=y
CONFIG_HID_PRIMAX=m
# CONFIG_HID_RETRODE is not set
CONFIG_HID_ROCCAT=m
CONFIG_HID_SAITEK=m
CONFIG_HID_SAMSUNG=m
CONFIG_HID_SONY=m
# CONFIG_SONY_FF is not set
CONFIG_HID_SPEEDLINK=m
# CONFIG_HID_STEAM is not set
CONFIG_HID_STEELSERIES=m
CONFIG_HID_SUNPLUS=m
CONFIG_HID_RMI=m
CONFIG_HID_GREENASIA=m
# CONFIG_GREENASIA_FF is not set
CONFIG_HID_HYPERV_MOUSE=m
CONFIG_HID_SMARTJOYPLUS=m
# CONFIG_SMARTJOYPLUS_FF is not set
CONFIG_HID_TIVO=m
CONFIG_HID_TOPSEED=m
CONFIG_HID_THINGM=m
CONFIG_HID_THRUSTMASTER=m
# CONFIG_THRUSTMASTER_FF is not set
# CONFIG_HID_UDRAW_PS3 is not set
# CONFIG_HID_U2FZERO is not set
CONFIG_HID_WACOM=m
CONFIG_HID_WIIMOTE=m
# CONFIG_HID_XINMO is not set
CONFIG_HID_ZEROPLUS=m
# CONFIG_ZEROPLUS_FF is not set
CONFIG_HID_ZYDACRON=m
CONFIG_HID_SENSOR_HUB=m
CONFIG_HID_SENSOR_CUSTOM_SENSOR=m
CONFIG_HID_ALPS=m
# end of Special HID drivers

#
# USB HID support
#
CONFIG_USB_HID=y
CONFIG_HID_PID=y
CONFIG_USB_HIDDEV=y
# end of USB HID support

#
# I2C HID support
#
CONFIG_I2C_HID=m
# end of I2C HID support

#
# Intel ISH HID support
#
CONFIG_INTEL_ISH_HID=y
# CONFIG_INTEL_ISH_FIRMWARE_DOWNLOADER is not set
# end of Intel ISH HID support
# end of HID support

CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=y
# CONFIG_USB_LED_TRIG is not set
# CONFIG_USB_ULPI_BUS is not set
# CONFIG_USB_CONN_GPIO is not set
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=y
CONFIG_USB_PCI=y
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEFAULT_PERSIST=y
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_OTG is not set
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
CONFIG_USB_LEDS_TRIGGER_USBPORT=m
CONFIG_USB_AUTOSUSPEND_DELAY=2
CONFIG_USB_MON=y

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=y
# CONFIG_USB_XHCI_DBGCAP is not set
CONFIG_USB_XHCI_PCI=y
# CONFIG_USB_XHCI_PLATFORM is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=y
# CONFIG_USB_EHCI_FSL is not set
# CONFIG_USB_EHCI_HCD_PLATFORM is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_FOTG210_HCD is not set
# CONFIG_USB_MAX3421_HCD is not set
CONFIG_USB_OHCI_HCD=y
CONFIG_USB_OHCI_HCD_PCI=y
# CONFIG_USB_OHCI_HCD_PLATFORM is not set
CONFIG_USB_UHCI_HCD=y
# CONFIG_USB_U132_HCD is not set
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_HCD_BCMA is not set
# CONFIG_USB_HCD_SSB is not set
# CONFIG_USB_HCD_TEST_MODE is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m
CONFIG_USB_WDM=m
CONFIG_USB_TMC=m

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_REALTEK=m
CONFIG_REALTEK_AUTOPM=y
CONFIG_USB_STORAGE_DATAFAB=m
CONFIG_USB_STORAGE_FREECOM=m
CONFIG_USB_STORAGE_ISD200=m
CONFIG_USB_STORAGE_USBAT=m
CONFIG_USB_STORAGE_SDDR09=m
CONFIG_USB_STORAGE_SDDR55=m
CONFIG_USB_STORAGE_JUMPSHOT=m
CONFIG_USB_STORAGE_ALAUDA=m
CONFIG_USB_STORAGE_ONETOUCH=m
CONFIG_USB_STORAGE_KARMA=m
CONFIG_USB_STORAGE_CYPRESS_ATACB=m
CONFIG_USB_STORAGE_ENE_UB6250=m
CONFIG_USB_UAS=m

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m
CONFIG_USB_MICROTEK=m
CONFIG_USBIP_CORE=m
# CONFIG_USBIP_VHCI_HCD is not set
# CONFIG_USBIP_HOST is not set
# CONFIG_USBIP_DEBUG is not set
# CONFIG_USB_CDNS3 is not set
# CONFIG_USB_MUSB_HDRC is not set
# CONFIG_USB_DWC3 is not set
# CONFIG_USB_DWC2 is not set
# CONFIG_USB_CHIPIDEA is not set
# CONFIG_USB_ISP1760 is not set

#
# USB port drivers
#
CONFIG_USB_USS720=m
CONFIG_USB_SERIAL=y
CONFIG_USB_SERIAL_CONSOLE=y
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_SIMPLE is not set
CONFIG_USB_SERIAL_AIRCABLE=m
CONFIG_USB_SERIAL_ARK3116=m
CONFIG_USB_SERIAL_BELKIN=m
CONFIG_USB_SERIAL_CH341=m
CONFIG_USB_SERIAL_WHITEHEAT=m
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
CONFIG_USB_SERIAL_CP210X=m
CONFIG_USB_SERIAL_CYPRESS_M8=m
CONFIG_USB_SERIAL_EMPEG=m
CONFIG_USB_SERIAL_FTDI_SIO=m
CONFIG_USB_SERIAL_VISOR=m
CONFIG_USB_SERIAL_IPAQ=m
CONFIG_USB_SERIAL_IR=m
CONFIG_USB_SERIAL_EDGEPORT=m
CONFIG_USB_SERIAL_EDGEPORT_TI=m
# CONFIG_USB_SERIAL_F81232 is not set
# CONFIG_USB_SERIAL_F8153X is not set
CONFIG_USB_SERIAL_GARMIN=m
CONFIG_USB_SERIAL_IPW=m
CONFIG_USB_SERIAL_IUU=m
CONFIG_USB_SERIAL_KEYSPAN_PDA=m
CONFIG_USB_SERIAL_KEYSPAN=m
CONFIG_USB_SERIAL_KLSI=m
CONFIG_USB_SERIAL_KOBIL_SCT=m
CONFIG_USB_SERIAL_MCT_U232=m
# CONFIG_USB_SERIAL_METRO is not set
CONFIG_USB_SERIAL_MOS7720=m
CONFIG_USB_SERIAL_MOS7715_PARPORT=y
CONFIG_USB_SERIAL_MOS7840=m
# CONFIG_USB_SERIAL_MXUPORT is not set
CONFIG_USB_SERIAL_NAVMAN=m
CONFIG_USB_SERIAL_PL2303=m
CONFIG_USB_SERIAL_OTI6858=m
CONFIG_USB_SERIAL_QCAUX=m
CONFIG_USB_SERIAL_QUALCOMM=m
CONFIG_USB_SERIAL_SPCP8X5=m
CONFIG_USB_SERIAL_SAFE=m
CONFIG_USB_SERIAL_SAFE_PADDED=y
CONFIG_USB_SERIAL_SIERRAWIRELESS=m
CONFIG_USB_SERIAL_SYMBOL=m
# CONFIG_USB_SERIAL_TI is not set
CONFIG_USB_SERIAL_CYBERJACK=m
CONFIG_USB_SERIAL_XIRCOM=m
CONFIG_USB_SERIAL_WWAN=m
CONFIG_USB_SERIAL_OPTION=m
CONFIG_USB_SERIAL_OMNINET=m
CONFIG_USB_SERIAL_OPTICON=m
CONFIG_USB_SERIAL_XSENS_MT=m
# CONFIG_USB_SERIAL_WISHBONE is not set
CONFIG_USB_SERIAL_SSU100=m
CONFIG_USB_SERIAL_QT2=m
# CONFIG_USB_SERIAL_UPD78F0730 is not set
CONFIG_USB_SERIAL_DEBUG=m

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=m
CONFIG_USB_EMI26=m
CONFIG_USB_ADUTUX=m
CONFIG_USB_SEVSEG=m
CONFIG_USB_LEGOTOWER=m
CONFIG_USB_LCD=m
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
CONFIG_USB_IDMOUSE=m
CONFIG_USB_FTDI_ELAN=m
CONFIG_USB_APPLEDISPLAY=m
CONFIG_USB_SISUSBVGA=m
CONFIG_USB_SISUSBVGA_CON=y
CONFIG_USB_LD=m
# CONFIG_USB_TRANCEVIBRATOR is not set
CONFIG_USB_IOWARRIOR=m
# CONFIG_USB_TEST is not set
# CONFIG_USB_EHSET_TEST_FIXTURE is not set
CONFIG_USB_ISIGHTFW=m
# CONFIG_USB_YUREX is not set
CONFIG_USB_EZUSB_FX2=m
# CONFIG_USB_HUB_USB251XB is not set
CONFIG_USB_HSIC_USB3503=m
# CONFIG_USB_HSIC_USB4604 is not set
# CONFIG_USB_LINK_LAYER_TEST is not set
# CONFIG_USB_CHAOSKEY is not set
CONFIG_USB_ATM=m
CONFIG_USB_SPEEDTOUCH=m
CONFIG_USB_CXACRU=m
CONFIG_USB_UEAGLEATM=m
CONFIG_USB_XUSBATM=m

#
# USB Physical Layer drivers
#
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_USB_ISP1301 is not set
# end of USB Physical Layer drivers

# CONFIG_USB_GADGET is not set
CONFIG_TYPEC=y
# CONFIG_TYPEC_TCPM is not set
CONFIG_TYPEC_UCSI=y
# CONFIG_UCSI_CCG is not set
CONFIG_UCSI_ACPI=y
# CONFIG_TYPEC_TPS6598X is not set

#
# USB Type-C Multiplexer/DeMultiplexer Switch support
#
# CONFIG_TYPEC_MUX_PI3USB30532 is not set
# end of USB Type-C Multiplexer/DeMultiplexer Switch support

#
# USB Type-C Alternate Mode drivers
#
# CONFIG_TYPEC_DP_ALTMODE is not set
# end of USB Type-C Alternate Mode drivers

# CONFIG_USB_ROLE_SWITCH is not set
CONFIG_MMC=m
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_MINORS=8
CONFIG_SDIO_UART=m
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
# CONFIG_MMC_DEBUG is not set
CONFIG_MMC_SDHCI=m
CONFIG_MMC_SDHCI_IO_ACCESSORS=y
CONFIG_MMC_SDHCI_PCI=m
CONFIG_MMC_RICOH_MMC=y
CONFIG_MMC_SDHCI_ACPI=m
CONFIG_MMC_SDHCI_PLTFM=m
# CONFIG_MMC_SDHCI_F_SDH30 is not set
# CONFIG_MMC_WBSD is not set
CONFIG_MMC_TIFM_SD=m
# CONFIG_MMC_SPI is not set
CONFIG_MMC_CB710=m
CONFIG_MMC_VIA_SDMMC=m
CONFIG_MMC_VUB300=m
CONFIG_MMC_USHC=m
# CONFIG_MMC_USDHI6ROL0 is not set
CONFIG_MMC_CQHCI=m
# CONFIG_MMC_TOSHIBA_PCI is not set
# CONFIG_MMC_MTK is not set
# CONFIG_MMC_SDHCI_XENON is not set
CONFIG_MEMSTICK=m
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
CONFIG_MSPRO_BLOCK=m
# CONFIG_MS_BLOCK is not set

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=m
CONFIG_MEMSTICK_JMICRON_38X=m
CONFIG_MEMSTICK_R592=m
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y
# CONFIG_LEDS_CLASS_FLASH is not set
# CONFIG_LEDS_BRIGHTNESS_HW_CHANGED is not set

#
# LED drivers
#
# CONFIG_LEDS_APU is not set
CONFIG_LEDS_LM3530=m
# CONFIG_LEDS_LM3532 is not set
# CONFIG_LEDS_LM3642 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_GPIO is not set
CONFIG_LEDS_LP3944=m
# CONFIG_LEDS_LP3952 is not set
CONFIG_LEDS_LP55XX_COMMON=m
CONFIG_LEDS_LP5521=m
CONFIG_LEDS_LP5523=m
CONFIG_LEDS_LP5562=m
# CONFIG_LEDS_LP8501 is not set
CONFIG_LEDS_CLEVO_MAIL=m
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA963X is not set
# CONFIG_LEDS_DAC124S085 is not set
# CONFIG_LEDS_PWM is not set
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_INTEL_SS4200=m
# CONFIG_LEDS_TCA6507 is not set
# CONFIG_LEDS_TLC591XX is not set
# CONFIG_LEDS_LM355x is not set

#
# LED driver for blink(1) USB RGB LED is under Special HID drivers (HID_THINGM)
#
CONFIG_LEDS_BLINKM=m
# CONFIG_LEDS_MLXCPLD is not set
# CONFIG_LEDS_MLXREG is not set
# CONFIG_LEDS_USER is not set
# CONFIG_LEDS_NIC78BX is not set
# CONFIG_LEDS_TI_LMU_COMMON is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_ONESHOT=m
# CONFIG_LEDS_TRIGGER_DISK is not set
# CONFIG_LEDS_TRIGGER_MTD is not set
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
CONFIG_LEDS_TRIGGER_BACKLIGHT=m
# CONFIG_LEDS_TRIGGER_CPU is not set
# CONFIG_LEDS_TRIGGER_ACTIVITY is not set
CONFIG_LEDS_TRIGGER_GPIO=m
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=m
CONFIG_LEDS_TRIGGER_CAMERA=m
# CONFIG_LEDS_TRIGGER_PANIC is not set
# CONFIG_LEDS_TRIGGER_NETDEV is not set
# CONFIG_LEDS_TRIGGER_PATTERN is not set
CONFIG_LEDS_TRIGGER_AUDIO=m
# CONFIG_ACCESSIBILITY is not set
CONFIG_INFINIBAND=m
CONFIG_INFINIBAND_USER_MAD=m
CONFIG_INFINIBAND_USER_ACCESS=m
# CONFIG_INFINIBAND_EXP_LEGACY_VERBS_NEW_UAPI is not set
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_ON_DEMAND_PAGING=y
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_ADDR_TRANS_CONFIGFS=y
# CONFIG_INFINIBAND_MTHCA is not set
# CONFIG_INFINIBAND_CXGB4 is not set
# CONFIG_INFINIBAND_EFA is not set
# CONFIG_INFINIBAND_I40IW is not set
# CONFIG_MLX4_INFINIBAND is not set
# CONFIG_INFINIBAND_OCRDMA is not set
# CONFIG_INFINIBAND_VMWARE_PVRDMA is not set
# CONFIG_INFINIBAND_USNIC is not set
# CONFIG_INFINIBAND_BNXT_RE is not set
# CONFIG_INFINIBAND_QEDR is not set
# CONFIG_INFINIBAND_RDMAVT is not set
CONFIG_RDMA_RXE=m
CONFIG_RDMA_SIW=m
CONFIG_INFINIBAND_IPOIB=m
# CONFIG_INFINIBAND_IPOIB_CM is not set
CONFIG_INFINIBAND_IPOIB_DEBUG=y
# CONFIG_INFINIBAND_IPOIB_DEBUG_DATA is not set
CONFIG_INFINIBAND_SRP=m
CONFIG_INFINIBAND_SRPT=m
# CONFIG_INFINIBAND_ISER is not set
# CONFIG_INFINIBAND_ISERT is not set
# CONFIG_INFINIBAND_OPA_VNIC is not set
CONFIG_EDAC_ATOMIC_SCRUB=y
CONFIG_EDAC_SUPPORT=y
CONFIG_EDAC=y
CONFIG_EDAC_LEGACY_SYSFS=y
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_DECODE_MCE=m
CONFIG_EDAC_GHES=y
CONFIG_EDAC_AMD64=m
# CONFIG_EDAC_AMD64_ERROR_INJECTION is not set
CONFIG_EDAC_E752X=m
CONFIG_EDAC_I82975X=m
CONFIG_EDAC_I3000=m
CONFIG_EDAC_I3200=m
CONFIG_EDAC_IE31200=m
CONFIG_EDAC_X38=m
CONFIG_EDAC_I5400=m
CONFIG_EDAC_I7CORE=m
CONFIG_EDAC_I5000=m
CONFIG_EDAC_I5100=m
CONFIG_EDAC_I7300=m
CONFIG_EDAC_SBRIDGE=m
CONFIG_EDAC_SKX=m
# CONFIG_EDAC_I10NM is not set
CONFIG_EDAC_PND2=m
CONFIG_RTC_LIB=y
CONFIG_RTC_MC146818_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_SYSTOHC is not set
# CONFIG_RTC_DEBUG is not set
CONFIG_RTC_NVMEM=y

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_ABB5ZES3 is not set
# CONFIG_RTC_DRV_ABEOZ9 is not set
# CONFIG_RTC_DRV_ABX80X is not set
CONFIG_RTC_DRV_DS1307=m
# CONFIG_RTC_DRV_DS1307_CENTURY is not set
CONFIG_RTC_DRV_DS1374=m
# CONFIG_RTC_DRV_DS1374_WDT is not set
CONFIG_RTC_DRV_DS1672=m
CONFIG_RTC_DRV_MAX6900=m
CONFIG_RTC_DRV_RS5C372=m
CONFIG_RTC_DRV_ISL1208=m
CONFIG_RTC_DRV_ISL12022=m
CONFIG_RTC_DRV_X1205=m
CONFIG_RTC_DRV_PCF8523=m
# CONFIG_RTC_DRV_PCF85063 is not set
# CONFIG_RTC_DRV_PCF85363 is not set
CONFIG_RTC_DRV_PCF8563=m
CONFIG_RTC_DRV_PCF8583=m
CONFIG_RTC_DRV_M41T80=m
CONFIG_RTC_DRV_M41T80_WDT=y
CONFIG_RTC_DRV_BQ32K=m
# CONFIG_RTC_DRV_S35390A is not set
CONFIG_RTC_DRV_FM3130=m
# CONFIG_RTC_DRV_RX8010 is not set
CONFIG_RTC_DRV_RX8581=m
CONFIG_RTC_DRV_RX8025=m
CONFIG_RTC_DRV_EM3027=m
# CONFIG_RTC_DRV_RV3028 is not set
# CONFIG_RTC_DRV_RV8803 is not set
# CONFIG_RTC_DRV_SD3078 is not set

#
# SPI RTC drivers
#
# CONFIG_RTC_DRV_M41T93 is not set
# CONFIG_RTC_DRV_M41T94 is not set
# CONFIG_RTC_DRV_DS1302 is not set
# CONFIG_RTC_DRV_DS1305 is not set
# CONFIG_RTC_DRV_DS1343 is not set
# CONFIG_RTC_DRV_DS1347 is not set
# CONFIG_RTC_DRV_DS1390 is not set
# CONFIG_RTC_DRV_MAX6916 is not set
# CONFIG_RTC_DRV_R9701 is not set
CONFIG_RTC_DRV_RX4581=m
# CONFIG_RTC_DRV_RX6110 is not set
# CONFIG_RTC_DRV_RS5C348 is not set
# CONFIG_RTC_DRV_MAX6902 is not set
# CONFIG_RTC_DRV_PCF2123 is not set
# CONFIG_RTC_DRV_MCP795 is not set
CONFIG_RTC_I2C_AND_SPI=y

#
# SPI and I2C RTC drivers
#
CONFIG_RTC_DRV_DS3232=m
CONFIG_RTC_DRV_DS3232_HWMON=y
# CONFIG_RTC_DRV_PCF2127 is not set
CONFIG_RTC_DRV_RV3029C2=m
CONFIG_RTC_DRV_RV3029_HWMON=y

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1286=m
CONFIG_RTC_DRV_DS1511=m
CONFIG_RTC_DRV_DS1553=m
# CONFIG_RTC_DRV_DS1685_FAMILY is not set
CONFIG_RTC_DRV_DS1742=m
CONFIG_RTC_DRV_DS2404=m
CONFIG_RTC_DRV_STK17TA8=m
# CONFIG_RTC_DRV_M48T86 is not set
CONFIG_RTC_DRV_M48T35=m
CONFIG_RTC_DRV_M48T59=m
CONFIG_RTC_DRV_MSM6242=m
CONFIG_RTC_DRV_BQ4802=m
CONFIG_RTC_DRV_RP5C01=m
CONFIG_RTC_DRV_V3020=m

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_FTRTC010 is not set

#
# HID Sensor RTC drivers
#
# CONFIG_RTC_DRV_HID_SENSOR_TIME is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_DMA_ENGINE=y
CONFIG_DMA_VIRTUAL_CHANNELS=y
CONFIG_DMA_ACPI=y
# CONFIG_ALTERA_MSGDMA is not set
# CONFIG_INTEL_IDMA64 is not set
# CONFIG_INTEL_IDXD is not set
CONFIG_INTEL_IOATDMA=m
# CONFIG_PLX_DMA is not set
# CONFIG_QCOM_HIDMA_MGMT is not set
# CONFIG_QCOM_HIDMA is not set
CONFIG_DW_DMAC_CORE=y
CONFIG_DW_DMAC=m
CONFIG_DW_DMAC_PCI=y
# CONFIG_DW_EDMA is not set
# CONFIG_DW_EDMA_PCIE is not set
CONFIG_HSU_DMA=y
# CONFIG_SF_PDMA is not set

#
# DMA Clients
#
CONFIG_ASYNC_TX_DMA=y
# CONFIG_DMATEST is not set
CONFIG_DMA_ENGINE_RAID=y

#
# DMABUF options
#
CONFIG_SYNC_FILE=y
CONFIG_SW_SYNC=y
# CONFIG_UDMABUF is not set
# CONFIG_DMABUF_SELFTESTS is not set
# CONFIG_DMABUF_HEAPS is not set
# end of DMABUF options

CONFIG_DCA=m
CONFIG_AUXDISPLAY=y
# CONFIG_HD44780 is not set
CONFIG_KS0108=m
CONFIG_KS0108_PORT=0x378
CONFIG_KS0108_DELAY=2
CONFIG_CFAG12864B=m
CONFIG_CFAG12864B_RATE=20
# CONFIG_IMG_ASCII_LCD is not set
# CONFIG_PARPORT_PANEL is not set
# CONFIG_CHARLCD_BL_OFF is not set
# CONFIG_CHARLCD_BL_ON is not set
CONFIG_CHARLCD_BL_FLASH=y
# CONFIG_PANEL is not set
CONFIG_UIO=m
CONFIG_UIO_CIF=m
CONFIG_UIO_PDRV_GENIRQ=m
# CONFIG_UIO_DMEM_GENIRQ is not set
CONFIG_UIO_AEC=m
CONFIG_UIO_SERCOS3=m
CONFIG_UIO_PCI_GENERIC=m
# CONFIG_UIO_NETX is not set
# CONFIG_UIO_PRUSS is not set
# CONFIG_UIO_MF624 is not set
CONFIG_UIO_HV_GENERIC=m
CONFIG_VFIO_IOMMU_TYPE1=m
CONFIG_VFIO_VIRQFD=m
CONFIG_VFIO=m
CONFIG_VFIO_NOIOMMU=y
CONFIG_VFIO_PCI=m
# CONFIG_VFIO_PCI_VGA is not set
CONFIG_VFIO_PCI_MMAP=y
CONFIG_VFIO_PCI_INTX=y
# CONFIG_VFIO_PCI_IGD is not set
CONFIG_VFIO_MDEV=m
CONFIG_VFIO_MDEV_DEVICE=m
CONFIG_IRQ_BYPASS_MANAGER=m
# CONFIG_VIRT_DRIVERS is not set
CONFIG_VIRTIO=y
CONFIG_VIRTIO_MENU=y
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_PCI_LEGACY=y
# CONFIG_VIRTIO_PMEM is not set
CONFIG_VIRTIO_BALLOON=y
CONFIG_VIRTIO_INPUT=m
# CONFIG_VIRTIO_MMIO is not set

#
# Microsoft Hyper-V guest support
#
CONFIG_HYPERV=m
CONFIG_HYPERV_TIMER=y
CONFIG_HYPERV_UTILS=m
CONFIG_HYPERV_BALLOON=m
# end of Microsoft Hyper-V guest support

#
# Xen driver support
#
CONFIG_XEN_BALLOON=y
# CONFIG_XEN_BALLOON_MEMORY_HOTPLUG is not set
CONFIG_XEN_SCRUB_PAGES_DEFAULT=y
CONFIG_XEN_DEV_EVTCHN=m
# CONFIG_XEN_BACKEND is not set
CONFIG_XENFS=m
CONFIG_XEN_COMPAT_XENFS=y
CONFIG_XEN_SYS_HYPERVISOR=y
CONFIG_XEN_XENBUS_FRONTEND=y
# CONFIG_XEN_GNTDEV is not set
# CONFIG_XEN_GRANT_DEV_ALLOC is not set
# CONFIG_XEN_GRANT_DMA_ALLOC is not set
CONFIG_SWIOTLB_XEN=y
# CONFIG_XEN_PVCALLS_FRONTEND is not set
CONFIG_XEN_PRIVCMD=m
CONFIG_XEN_HAVE_PVMMU=y
CONFIG_XEN_EFI=y
CONFIG_XEN_AUTO_XLATE=y
CONFIG_XEN_ACPI=y
CONFIG_XEN_HAVE_VPMU=y
# end of Xen driver support

# CONFIG_GREYBUS is not set
CONFIG_STAGING=y
# CONFIG_PRISM2_USB is not set
# CONFIG_COMEDI is not set
# CONFIG_RTL8192U is not set
CONFIG_RTLLIB=m
CONFIG_RTLLIB_CRYPTO_CCMP=m
CONFIG_RTLLIB_CRYPTO_TKIP=m
CONFIG_RTLLIB_CRYPTO_WEP=m
CONFIG_RTL8192E=m
# CONFIG_RTL8723BS is not set
CONFIG_R8712U=m
# CONFIG_R8188EU is not set
# CONFIG_RTS5208 is not set
# CONFIG_VT6655 is not set
# CONFIG_VT6656 is not set

#
# IIO staging drivers
#

#
# Accelerometers
#
# CONFIG_ADIS16203 is not set
# CONFIG_ADIS16240 is not set
# end of Accelerometers

#
# Analog to digital converters
#
# CONFIG_AD7816 is not set
# CONFIG_AD7192 is not set
# CONFIG_AD7280 is not set
# end of Analog to digital converters

#
# Analog digital bi-direction converters
#
# CONFIG_ADT7316 is not set
# end of Analog digital bi-direction converters

#
# Capacitance to digital converters
#
# CONFIG_AD7150 is not set
# CONFIG_AD7746 is not set
# end of Capacitance to digital converters

#
# Direct Digital Synthesis
#
# CONFIG_AD9832 is not set
# CONFIG_AD9834 is not set
# end of Direct Digital Synthesis

#
# Network Analyzer, Impedance Converters
#
# CONFIG_AD5933 is not set
# end of Network Analyzer, Impedance Converters

#
# Active energy metering IC
#
# CONFIG_ADE7854 is not set
# end of Active energy metering IC

#
# Resolver to digital converters
#
# CONFIG_AD2S1210 is not set
# end of Resolver to digital converters
# end of IIO staging drivers

# CONFIG_FB_SM750 is not set

#
# Speakup console speech
#
# CONFIG_SPEAKUP is not set
# end of Speakup console speech

# CONFIG_STAGING_MEDIA is not set

#
# Android
#
# CONFIG_ASHMEM is not set
# CONFIG_ANDROID_VSOC is not set
CONFIG_ION=y
CONFIG_ION_SYSTEM_HEAP=y
# CONFIG_ION_CMA_HEAP is not set
# end of Android

# CONFIG_LTE_GDM724X is not set
CONFIG_FIREWIRE_SERIAL=m
CONFIG_FWTTY_MAX_TOTAL_PORTS=64
CONFIG_FWTTY_MAX_CARD_PORTS=32
# CONFIG_GS_FPGABOOT is not set
# CONFIG_UNISYSSPAR is not set
# CONFIG_FB_TFT is not set
# CONFIG_WILC1000_SDIO is not set
# CONFIG_WILC1000_SPI is not set
# CONFIG_MOST is not set
# CONFIG_KS7010 is not set
# CONFIG_PI433 is not set

#
# Gasket devices
#
# CONFIG_STAGING_GASKET_FRAMEWORK is not set
# end of Gasket devices

# CONFIG_FIELDBUS_DEV is not set
# CONFIG_KPC2000 is not set
CONFIG_USB_WUSB=m
CONFIG_USB_WUSB_CBAF=m
# CONFIG_USB_WUSB_CBAF_DEBUG is not set
# CONFIG_USB_WHCI_HCD is not set
CONFIG_USB_HWA_HCD=m
CONFIG_UWB=m
CONFIG_UWB_HWA=m
CONFIG_UWB_WHCI=m
CONFIG_UWB_I1480U=m
# CONFIG_STAGING_EXFAT_FS is not set
CONFIG_QLGE=m
# CONFIG_NET_VENDOR_HP is not set
# CONFIG_WFX is not set
CONFIG_X86_PLATFORM_DEVICES=y
CONFIG_ACER_WMI=m
# CONFIG_ACER_WIRELESS is not set
CONFIG_ACERHDF=m
# CONFIG_ALIENWARE_WMI is not set
CONFIG_ASUS_LAPTOP=m
CONFIG_DCDBAS=m
CONFIG_DELL_SMBIOS=m
CONFIG_DELL_SMBIOS_WMI=y
CONFIG_DELL_SMBIOS_SMM=y
CONFIG_DELL_LAPTOP=m
CONFIG_DELL_WMI=m
CONFIG_DELL_WMI_DESCRIPTOR=m
CONFIG_DELL_WMI_AIO=m
# CONFIG_DELL_WMI_LED is not set
CONFIG_DELL_SMO8800=m
CONFIG_DELL_RBTN=m
CONFIG_DELL_RBU=m
CONFIG_FUJITSU_LAPTOP=m
CONFIG_FUJITSU_TABLET=m
CONFIG_AMILO_RFKILL=m
# CONFIG_GPD_POCKET_FAN is not set
CONFIG_HP_ACCEL=m
CONFIG_HP_WIRELESS=m
CONFIG_HP_WMI=m
# CONFIG_LG_LAPTOP is not set
CONFIG_MSI_LAPTOP=m
CONFIG_PANASONIC_LAPTOP=m
CONFIG_COMPAL_LAPTOP=m
CONFIG_SONY_LAPTOP=m
CONFIG_SONYPI_COMPAT=y
CONFIG_IDEAPAD_LAPTOP=m
# CONFIG_SURFACE3_WMI is not set
CONFIG_THINKPAD_ACPI=m
CONFIG_THINKPAD_ACPI_ALSA_SUPPORT=y
# CONFIG_THINKPAD_ACPI_DEBUGFACILITIES is not set
# CONFIG_THINKPAD_ACPI_DEBUG is not set
# CONFIG_THINKPAD_ACPI_UNSAFE_LEDS is not set
CONFIG_THINKPAD_ACPI_VIDEO=y
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
CONFIG_SENSORS_HDAPS=m
# CONFIG_INTEL_MENLOW is not set
CONFIG_EEEPC_LAPTOP=m
CONFIG_ASUS_WMI=m
CONFIG_ASUS_NB_WMI=m
CONFIG_EEEPC_WMI=m
# CONFIG_ASUS_WIRELESS is not set
CONFIG_ACPI_WMI=m
CONFIG_WMI_BMOF=m
CONFIG_INTEL_WMI_THUNDERBOLT=m
# CONFIG_XIAOMI_WMI is not set
CONFIG_MSI_WMI=m
# CONFIG_PEAQ_WMI is not set
CONFIG_TOPSTAR_LAPTOP=m
CONFIG_ACPI_TOSHIBA=m
CONFIG_TOSHIBA_BT_RFKILL=m
# CONFIG_TOSHIBA_HAPS is not set
# CONFIG_TOSHIBA_WMI is not set
CONFIG_ACPI_CMPC=m
# CONFIG_INTEL_INT0002_VGPIO is not set
CONFIG_INTEL_HID_EVENT=m
CONFIG_INTEL_VBTN=m
CONFIG_INTEL_IPS=m
CONFIG_INTEL_PMC_CORE=m
# CONFIG_IBM_RTL is not set
CONFIG_SAMSUNG_LAPTOP=m
CONFIG_MXM_WMI=m
CONFIG_INTEL_OAKTRAIL=m
CONFIG_SAMSUNG_Q10=m
CONFIG_APPLE_GMUX=m
# CONFIG_INTEL_RST is not set
# CONFIG_INTEL_SMARTCONNECT is not set
# CONFIG_INTEL_PMC_IPC is not set
# CONFIG_SURFACE_PRO3_BUTTON is not set
# CONFIG_INTEL_PUNIT_IPC is not set
# CONFIG_MLX_PLATFORM is not set
# CONFIG_INTEL_TURBO_MAX_3 is not set
# CONFIG_I2C_MULTI_INSTANTIATE is not set
# CONFIG_INTEL_ATOMISP2_PM is not set
# CONFIG_HUAWEI_WMI is not set
# CONFIG_PCENGINES_APU2 is not set
# CONFIG_INTEL_UNCORE_FREQ_CONTROL is not set

#
# Intel Speed Select Technology interface support
#
# CONFIG_INTEL_SPEED_SELECT_INTERFACE is not set
# end of Intel Speed Select Technology interface support

# CONFIG_SYSTEM76_ACPI is not set
CONFIG_PMC_ATOM=y
# CONFIG_MFD_CROS_EC is not set
# CONFIG_CHROME_PLATFORMS is not set
# CONFIG_MELLANOX_PLATFORM is not set
CONFIG_CLKDEV_LOOKUP=y
CONFIG_HAVE_CLK_PREPARE=y
CONFIG_COMMON_CLK=y

#
# Common Clock Framework
#
# CONFIG_COMMON_CLK_MAX9485 is not set
# CONFIG_COMMON_CLK_SI5341 is not set
# CONFIG_COMMON_CLK_SI5351 is not set
# CONFIG_COMMON_CLK_SI544 is not set
# CONFIG_COMMON_CLK_CDCE706 is not set
# CONFIG_COMMON_CLK_CS2000_CP is not set
# CONFIG_COMMON_CLK_PWM is not set
# end of Common Clock Framework

# CONFIG_HWSPINLOCK is not set

#
# Clock Source drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_I8253_LOCK=y
CONFIG_CLKBLD_I8253=y
# end of Clock Source drivers

CONFIG_MAILBOX=y
CONFIG_PCC=y
# CONFIG_ALTERA_MBOX is not set
CONFIG_IOMMU_IOVA=y
CONFIG_IOMMU_API=y
CONFIG_IOMMU_SUPPORT=y

#
# Generic IOMMU Pagetable Support
#
# end of Generic IOMMU Pagetable Support

# CONFIG_IOMMU_DEBUGFS is not set
# CONFIG_IOMMU_DEFAULT_PASSTHROUGH is not set
CONFIG_IOMMU_DMA=y
CONFIG_AMD_IOMMU=y
CONFIG_AMD_IOMMU_V2=m
CONFIG_DMAR_TABLE=y
CONFIG_INTEL_IOMMU=y
# CONFIG_INTEL_IOMMU_SVM is not set
# CONFIG_INTEL_IOMMU_DEFAULT_ON is not set
CONFIG_INTEL_IOMMU_FLOPPY_WA=y
# CONFIG_INTEL_IOMMU_SCALABLE_MODE_DEFAULT_ON is not set
CONFIG_IRQ_REMAP=y
CONFIG_HYPERV_IOMMU=y

#
# Remoteproc drivers
#
# CONFIG_REMOTEPROC is not set
# end of Remoteproc drivers

#
# Rpmsg drivers
#
# CONFIG_RPMSG_QCOM_GLINK_RPM is not set
# CONFIG_RPMSG_VIRTIO is not set
# end of Rpmsg drivers

# CONFIG_SOUNDWIRE is not set

#
# SOC (System On Chip) specific Drivers
#

#
# Amlogic SoC drivers
#
# end of Amlogic SoC drivers

#
# Aspeed SoC drivers
#
# end of Aspeed SoC drivers

#
# Broadcom SoC drivers
#
# end of Broadcom SoC drivers

#
# NXP/Freescale QorIQ SoC drivers
#
# end of NXP/Freescale QorIQ SoC drivers

#
# i.MX SoC drivers
#
# end of i.MX SoC drivers

#
# Qualcomm SoC drivers
#
# end of Qualcomm SoC drivers

# CONFIG_SOC_TI is not set

#
# Xilinx SoC drivers
#
# CONFIG_XILINX_VCU is not set
# end of Xilinx SoC drivers
# end of SOC (System On Chip) specific Drivers

CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=m
# CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
# CONFIG_DEVFREQ_GOV_POWERSAVE is not set
# CONFIG_DEVFREQ_GOV_USERSPACE is not set
# CONFIG_DEVFREQ_GOV_PASSIVE is not set

#
# DEVFREQ Drivers
#
# CONFIG_PM_DEVFREQ_EVENT is not set
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
CONFIG_IIO=y
CONFIG_IIO_BUFFER=y
CONFIG_IIO_BUFFER_CB=y
# CONFIG_IIO_BUFFER_HW_CONSUMER is not set
CONFIG_IIO_KFIFO_BUF=y
CONFIG_IIO_TRIGGERED_BUFFER=m
# CONFIG_IIO_CONFIGFS is not set
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2
# CONFIG_IIO_SW_DEVICE is not set
# CONFIG_IIO_SW_TRIGGER is not set

#
# Accelerometers
#
# CONFIG_ADIS16201 is not set
# CONFIG_ADIS16209 is not set
# CONFIG_ADXL345_I2C is not set
# CONFIG_ADXL345_SPI is not set
# CONFIG_ADXL372_SPI is not set
# CONFIG_ADXL372_I2C is not set
# CONFIG_BMA180 is not set
# CONFIG_BMA220 is not set
# CONFIG_BMA400 is not set
# CONFIG_BMC150_ACCEL is not set
# CONFIG_DA280 is not set
# CONFIG_DA311 is not set
# CONFIG_DMARD09 is not set
# CONFIG_DMARD10 is not set
CONFIG_HID_SENSOR_ACCEL_3D=m
# CONFIG_IIO_ST_ACCEL_3AXIS is not set
# CONFIG_KXSD9 is not set
# CONFIG_KXCJK1013 is not set
# CONFIG_MC3230 is not set
# CONFIG_MMA7455_I2C is not set
# CONFIG_MMA7455_SPI is not set
# CONFIG_MMA7660 is not set
# CONFIG_MMA8452 is not set
# CONFIG_MMA9551 is not set
# CONFIG_MMA9553 is not set
# CONFIG_MXC4005 is not set
# CONFIG_MXC6255 is not set
# CONFIG_SCA3000 is not set
# CONFIG_STK8312 is not set
# CONFIG_STK8BA50 is not set
# end of Accelerometers

#
# Analog to digital converters
#
# CONFIG_AD7091R5 is not set
# CONFIG_AD7124 is not set
# CONFIG_AD7266 is not set
# CONFIG_AD7291 is not set
# CONFIG_AD7292 is not set
# CONFIG_AD7298 is not set
# CONFIG_AD7476 is not set
# CONFIG_AD7606_IFACE_PARALLEL is not set
# CONFIG_AD7606_IFACE_SPI is not set
# CONFIG_AD7766 is not set
# CONFIG_AD7768_1 is not set
# CONFIG_AD7780 is not set
# CONFIG_AD7791 is not set
# CONFIG_AD7793 is not set
# CONFIG_AD7887 is not set
# CONFIG_AD7923 is not set
# CONFIG_AD7949 is not set
# CONFIG_AD799X is not set
# CONFIG_HI8435 is not set
# CONFIG_HX711 is not set
# CONFIG_INA2XX_ADC is not set
# CONFIG_LTC2471 is not set
# CONFIG_LTC2485 is not set
# CONFIG_LTC2496 is not set
# CONFIG_LTC2497 is not set
# CONFIG_MAX1027 is not set
# CONFIG_MAX11100 is not set
# CONFIG_MAX1118 is not set
# CONFIG_MAX1363 is not set
# CONFIG_MAX9611 is not set
# CONFIG_MCP320X is not set
# CONFIG_MCP3422 is not set
# CONFIG_MCP3911 is not set
# CONFIG_NAU7802 is not set
# CONFIG_TI_ADC081C is not set
# CONFIG_TI_ADC0832 is not set
# CONFIG_TI_ADC084S021 is not set
# CONFIG_TI_ADC12138 is not set
# CONFIG_TI_ADC108S102 is not set
# CONFIG_TI_ADC128S052 is not set
# CONFIG_TI_ADC161S626 is not set
# CONFIG_TI_ADS1015 is not set
# CONFIG_TI_ADS7950 is not set
# CONFIG_TI_TLC4541 is not set
# CONFIG_VIPERBOARD_ADC is not set
# CONFIG_XILINX_XADC is not set
# end of Analog to digital converters

#
# Analog Front Ends
#
# end of Analog Front Ends

#
# Amplifiers
#
# CONFIG_AD8366 is not set
# end of Amplifiers

#
# Chemical Sensors
#
# CONFIG_ATLAS_PH_SENSOR is not set
# CONFIG_BME680 is not set
# CONFIG_CCS811 is not set
# CONFIG_IAQCORE is not set
# CONFIG_SENSIRION_SGP30 is not set
# CONFIG_SPS30 is not set
# CONFIG_VZ89X is not set
# end of Chemical Sensors

#
# Hid Sensor IIO Common
#
CONFIG_HID_SENSOR_IIO_COMMON=m
CONFIG_HID_SENSOR_IIO_TRIGGER=m
# end of Hid Sensor IIO Common

#
# SSP Sensor Common
#
# CONFIG_IIO_SSP_SENSORHUB is not set
# end of SSP Sensor Common

#
# Digital to analog converters
#
# CONFIG_AD5064 is not set
# CONFIG_AD5360 is not set
# CONFIG_AD5380 is not set
# CONFIG_AD5421 is not set
# CONFIG_AD5446 is not set
# CONFIG_AD5449 is not set
# CONFIG_AD5592R is not set
# CONFIG_AD5593R is not set
# CONFIG_AD5504 is not set
# CONFIG_AD5624R_SPI is not set
# CONFIG_LTC1660 is not set
# CONFIG_LTC2632 is not set
# CONFIG_AD5686_SPI is not set
# CONFIG_AD5696_I2C is not set
# CONFIG_AD5755 is not set
# CONFIG_AD5758 is not set
# CONFIG_AD5761 is not set
# CONFIG_AD5764 is not set
# CONFIG_AD5791 is not set
# CONFIG_AD7303 is not set
# CONFIG_AD8801 is not set
# CONFIG_DS4424 is not set
# CONFIG_M62332 is not set
# CONFIG_MAX517 is not set
# CONFIG_MCP4725 is not set
# CONFIG_MCP4922 is not set
# CONFIG_TI_DAC082S085 is not set
# CONFIG_TI_DAC5571 is not set
# CONFIG_TI_DAC7311 is not set
# CONFIG_TI_DAC7612 is not set
# end of Digital to analog converters

#
# IIO dummy driver
#
# end of IIO dummy driver

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#
# CONFIG_AD9523 is not set
# end of Clock Generator/Distribution

#
# Phase-Locked Loop (PLL) frequency synthesizers
#
# CONFIG_ADF4350 is not set
# CONFIG_ADF4371 is not set
# end of Phase-Locked Loop (PLL) frequency synthesizers
# end of Frequency Synthesizers DDS/PLL

#
# Digital gyroscope sensors
#
# CONFIG_ADIS16080 is not set
# CONFIG_ADIS16130 is not set
# CONFIG_ADIS16136 is not set
# CONFIG_ADIS16260 is not set
# CONFIG_ADXRS450 is not set
# CONFIG_BMG160 is not set
# CONFIG_FXAS21002C is not set
CONFIG_HID_SENSOR_GYRO_3D=m
# CONFIG_MPU3050_I2C is not set
# CONFIG_IIO_ST_GYRO_3AXIS is not set
# CONFIG_ITG3200 is not set
# end of Digital gyroscope sensors

#
# Health Sensors
#

#
# Heart Rate Monitors
#
# CONFIG_AFE4403 is not set
# CONFIG_AFE4404 is not set
# CONFIG_MAX30100 is not set
# CONFIG_MAX30102 is not set
# end of Heart Rate Monitors
# end of Health Sensors

#
# Humidity sensors
#
# CONFIG_AM2315 is not set
# CONFIG_DHT11 is not set
# CONFIG_HDC100X is not set
# CONFIG_HID_SENSOR_HUMIDITY is not set
# CONFIG_HTS221 is not set
# CONFIG_HTU21 is not set
# CONFIG_SI7005 is not set
# CONFIG_SI7020 is not set
# end of Humidity sensors

#
# Inertial measurement units
#
# CONFIG_ADIS16400 is not set
# CONFIG_ADIS16460 is not set
# CONFIG_ADIS16480 is not set
# CONFIG_BMI160_I2C is not set
# CONFIG_BMI160_SPI is not set
# CONFIG_FXOS8700_I2C is not set
# CONFIG_FXOS8700_SPI is not set
# CONFIG_KMX61 is not set
# CONFIG_INV_MPU6050_I2C is not set
# CONFIG_INV_MPU6050_SPI is not set
# CONFIG_IIO_ST_LSM6DSX is not set
# end of Inertial measurement units

#
# Light sensors
#
# CONFIG_ACPI_ALS is not set
# CONFIG_ADJD_S311 is not set
# CONFIG_ADUX1020 is not set
# CONFIG_AL3320A is not set
# CONFIG_APDS9300 is not set
# CONFIG_APDS9960 is not set
# CONFIG_BH1750 is not set
# CONFIG_BH1780 is not set
# CONFIG_CM32181 is not set
# CONFIG_CM3232 is not set
# CONFIG_CM3323 is not set
# CONFIG_CM36651 is not set
# CONFIG_GP2AP020A00F is not set
# CONFIG_SENSORS_ISL29018 is not set
# CONFIG_SENSORS_ISL29028 is not set
# CONFIG_ISL29125 is not set
CONFIG_HID_SENSOR_ALS=m
CONFIG_HID_SENSOR_PROX=m
# CONFIG_JSA1212 is not set
# CONFIG_RPR0521 is not set
# CONFIG_LTR501 is not set
# CONFIG_LV0104CS is not set
# CONFIG_MAX44000 is not set
# CONFIG_MAX44009 is not set
# CONFIG_NOA1305 is not set
# CONFIG_OPT3001 is not set
# CONFIG_PA12203001 is not set
# CONFIG_SI1133 is not set
# CONFIG_SI1145 is not set
# CONFIG_STK3310 is not set
# CONFIG_ST_UVIS25 is not set
# CONFIG_TCS3414 is not set
# CONFIG_TCS3472 is not set
# CONFIG_SENSORS_TSL2563 is not set
# CONFIG_TSL2583 is not set
# CONFIG_TSL2772 is not set
# CONFIG_TSL4531 is not set
# CONFIG_US5182D is not set
# CONFIG_VCNL4000 is not set
# CONFIG_VCNL4035 is not set
# CONFIG_VEML6030 is not set
# CONFIG_VEML6070 is not set
# CONFIG_VL6180 is not set
# CONFIG_ZOPT2201 is not set
# end of Light sensors

#
# Magnetometer sensors
#
# CONFIG_AK8975 is not set
# CONFIG_AK09911 is not set
# CONFIG_BMC150_MAGN_I2C is not set
# CONFIG_BMC150_MAGN_SPI is not set
# CONFIG_MAG3110 is not set
CONFIG_HID_SENSOR_MAGNETOMETER_3D=m
# CONFIG_MMC35240 is not set
# CONFIG_IIO_ST_MAGN_3AXIS is not set
# CONFIG_SENSORS_HMC5843_I2C is not set
# CONFIG_SENSORS_HMC5843_SPI is not set
# CONFIG_SENSORS_RM3100_I2C is not set
# CONFIG_SENSORS_RM3100_SPI is not set
# end of Magnetometer sensors

#
# Multiplexers
#
# end of Multiplexers

#
# Inclinometer sensors
#
CONFIG_HID_SENSOR_INCLINOMETER_3D=m
CONFIG_HID_SENSOR_DEVICE_ROTATION=m
# end of Inclinometer sensors

#
# Triggers - standalone
#
# CONFIG_IIO_INTERRUPT_TRIGGER is not set
# CONFIG_IIO_SYSFS_TRIGGER is not set
# end of Triggers - standalone

#
# Digital potentiometers
#
# CONFIG_AD5272 is not set
# CONFIG_DS1803 is not set
# CONFIG_MAX5432 is not set
# CONFIG_MAX5481 is not set
# CONFIG_MAX5487 is not set
# CONFIG_MCP4018 is not set
# CONFIG_MCP4131 is not set
# CONFIG_MCP4531 is not set
# CONFIG_MCP41010 is not set
# CONFIG_TPL0102 is not set
# end of Digital potentiometers

#
# Digital potentiostats
#
# CONFIG_LMP91000 is not set
# end of Digital potentiostats

#
# Pressure sensors
#
# CONFIG_ABP060MG is not set
# CONFIG_BMP280 is not set
# CONFIG_DLHL60D is not set
# CONFIG_DPS310 is not set
CONFIG_HID_SENSOR_PRESS=m
# CONFIG_HP03 is not set
# CONFIG_MPL115_I2C is not set
# CONFIG_MPL115_SPI is not set
# CONFIG_MPL3115 is not set
# CONFIG_MS5611 is not set
# CONFIG_MS5637 is not set
# CONFIG_IIO_ST_PRESS is not set
# CONFIG_T5403 is not set
# CONFIG_HP206C is not set
# CONFIG_ZPA2326 is not set
# end of Pressure sensors

#
# Lightning sensors
#
# CONFIG_AS3935 is not set
# end of Lightning sensors

#
# Proximity and distance sensors
#
# CONFIG_ISL29501 is not set
# CONFIG_LIDAR_LITE_V2 is not set
# CONFIG_MB1232 is not set
# CONFIG_PING is not set
# CONFIG_RFD77402 is not set
# CONFIG_SRF04 is not set
# CONFIG_SX9500 is not set
# CONFIG_SRF08 is not set
# CONFIG_VL53L0X_I2C is not set
# end of Proximity and distance sensors

#
# Resolver to digital converters
#
# CONFIG_AD2S90 is not set
# CONFIG_AD2S1200 is not set
# end of Resolver to digital converters

#
# Temperature sensors
#
# CONFIG_LTC2983 is not set
# CONFIG_MAXIM_THERMOCOUPLE is not set
# CONFIG_HID_SENSOR_TEMP is not set
# CONFIG_MLX90614 is not set
# CONFIG_MLX90632 is not set
# CONFIG_TMP006 is not set
# CONFIG_TMP007 is not set
# CONFIG_TSYS01 is not set
# CONFIG_TSYS02D is not set
# CONFIG_MAX31856 is not set
# end of Temperature sensors

CONFIG_NTB=m
# CONFIG_NTB_MSI is not set
CONFIG_NTB_AMD=m
# CONFIG_NTB_IDT is not set
# CONFIG_NTB_INTEL is not set
# CONFIG_NTB_SWITCHTEC is not set
# CONFIG_NTB_PINGPONG is not set
# CONFIG_NTB_TOOL is not set
CONFIG_NTB_PERF=m
CONFIG_NTB_TRANSPORT=m
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
CONFIG_PWM_SYSFS=y
# CONFIG_PWM_LPSS_PCI is not set
# CONFIG_PWM_LPSS_PLATFORM is not set
# CONFIG_PWM_PCA9685 is not set

#
# IRQ chip support
#
# end of IRQ chip support

# CONFIG_IPACK_BUS is not set
# CONFIG_RESET_CONTROLLER is not set

#
# PHY Subsystem
#
CONFIG_GENERIC_PHY=y
# CONFIG_BCM_KONA_USB2_PHY is not set
# CONFIG_PHY_PXA_28NM_HSIC is not set
# CONFIG_PHY_PXA_28NM_USB2 is not set
# CONFIG_PHY_CPCAP_USB is not set
# CONFIG_PHY_INTEL_EMMC is not set
# end of PHY Subsystem

CONFIG_POWERCAP=y
CONFIG_INTEL_RAPL_CORE=m
CONFIG_INTEL_RAPL=m
# CONFIG_IDLE_INJECT is not set
# CONFIG_MCB is not set

#
# Performance monitor support
#
# end of Performance monitor support

CONFIG_RAS=y
# CONFIG_RAS_CEC is not set
# CONFIG_USB4 is not set

#
# Android
#
CONFIG_ANDROID=y
# CONFIG_ANDROID_BINDER_IPC is not set
# end of Android

CONFIG_LIBNVDIMM=m
CONFIG_BLK_DEV_PMEM=m
CONFIG_ND_BLK=m
CONFIG_ND_CLAIM=y
CONFIG_ND_BTT=m
CONFIG_BTT=y
CONFIG_ND_PFN=m
CONFIG_NVDIMM_PFN=y
CONFIG_NVDIMM_DAX=y
CONFIG_NVDIMM_KEYS=y
CONFIG_DAX_DRIVER=y
CONFIG_DAX=y
CONFIG_DEV_DAX=m
CONFIG_DEV_DAX_PMEM=m
CONFIG_DEV_DAX_KMEM=m
CONFIG_DEV_DAX_PMEM_COMPAT=m
CONFIG_NVMEM=y
CONFIG_NVMEM_SYSFS=y

#
# HW tracing support
#
# CONFIG_STM is not set
# CONFIG_INTEL_TH is not set
# end of HW tracing support

# CONFIG_FPGA is not set
# CONFIG_TEE is not set
CONFIG_PM_OPP=y
# CONFIG_UNISYS_VISORBUS is not set
# CONFIG_SIOX is not set
# CONFIG_SLIMBUS is not set
# CONFIG_INTERCONNECT is not set
# CONFIG_COUNTER is not set
# end of Device Drivers

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_VALIDATE_FS_PARSER is not set
CONFIG_FS_IOMAP=y
# CONFIG_EXT2_FS is not set
# CONFIG_EXT3_FS is not set
CONFIG_EXT4_FS=m
CONFIG_EXT4_USE_FOR_EXT2=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_JBD2=m
# CONFIG_JBD2_DEBUG is not set
CONFIG_FS_MBCACHE=m
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=m
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
CONFIG_XFS_ONLINE_SCRUB=y
CONFIG_XFS_ONLINE_REPAIR=y
CONFIG_XFS_DEBUG=y
CONFIG_XFS_ASSERT_FATAL=y
CONFIG_GFS2_FS=m
CONFIG_GFS2_FS_LOCKING_DLM=y
CONFIG_OCFS2_FS=m
CONFIG_OCFS2_FS_O2CB=m
CONFIG_OCFS2_FS_USERSPACE_CLUSTER=m
CONFIG_OCFS2_FS_STATS=y
CONFIG_OCFS2_DEBUG_MASKLOG=y
# CONFIG_OCFS2_DEBUG_FS is not set
CONFIG_BTRFS_FS=m
CONFIG_BTRFS_FS_POSIX_ACL=y
# CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
# CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
# CONFIG_BTRFS_DEBUG is not set
# CONFIG_BTRFS_ASSERT is not set
# CONFIG_BTRFS_FS_REF_VERIFY is not set
# CONFIG_NILFS2_FS is not set
CONFIG_F2FS_FS=m
CONFIG_F2FS_STAT_FS=y
CONFIG_F2FS_FS_XATTR=y
CONFIG_F2FS_FS_POSIX_ACL=y
CONFIG_F2FS_FS_SECURITY=y
# CONFIG_F2FS_CHECK_FS is not set
# CONFIG_F2FS_IO_TRACE is not set
# CONFIG_F2FS_FAULT_INJECTION is not set
# CONFIG_F2FS_FS_COMPRESSION is not set
# CONFIG_ZONEFS_FS is not set
CONFIG_FS_DAX=y
CONFIG_FS_DAX_PMD=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_EXPORTFS_BLOCK_OPS=y
CONFIG_FILE_LOCKING=y
CONFIG_MANDATORY_FILE_LOCKING=y
CONFIG_FS_ENCRYPTION=y
CONFIG_FS_ENCRYPTION_ALGS=m
# CONFIG_FS_VERITY is not set
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
CONFIG_FANOTIFY_ACCESS_PERMISSIONS=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_PRINT_QUOTA_WARNING=y
# CONFIG_QUOTA_DEBUG is not set
CONFIG_QUOTA_TREE=y
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_QUOTACTL_COMPAT=y
CONFIG_AUTOFS4_FS=y
CONFIG_AUTOFS_FS=y
CONFIG_FUSE_FS=m
CONFIG_CUSE=m
# CONFIG_VIRTIO_FS is not set
CONFIG_OVERLAY_FS=m
# CONFIG_OVERLAY_FS_REDIRECT_DIR is not set
# CONFIG_OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW is not set
# CONFIG_OVERLAY_FS_INDEX is not set
# CONFIG_OVERLAY_FS_XINO_AUTO is not set
# CONFIG_OVERLAY_FS_METACOPY is not set

#
# Caches
#
CONFIG_FSCACHE=m
CONFIG_FSCACHE_STATS=y
# CONFIG_FSCACHE_HISTOGRAM is not set
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_FSCACHE_OBJECT_LIST is not set
CONFIG_CACHEFILES=m
# CONFIG_CACHEFILES_DEBUG is not set
# CONFIG_CACHEFILES_HISTOGRAM is not set
# end of Caches

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=m
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
# end of CD-ROM/DVD Filesystems

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="ascii"
# CONFIG_FAT_DEFAULT_UTF8 is not set
# CONFIG_NTFS_FS is not set
# end of DOS/FAT/NT Filesystems

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
# CONFIG_PROC_VMCORE_DEVICE_DUMP is not set
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_PROC_CHILDREN=y
CONFIG_PROC_PID_ARCH_STATUS=y
CONFIG_PROC_CPU_RESCTRL=y
CONFIG_KERNFS=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_MEMFD_CREATE=y
CONFIG_ARCH_HAS_GIGANTIC_PAGE=y
CONFIG_CONFIGFS_FS=y
CONFIG_EFIVAR_FS=y
# end of Pseudo filesystems

CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ORANGEFS_FS is not set
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
# CONFIG_HFS_FS is not set
# CONFIG_HFSPLUS_FS is not set
# CONFIG_BEFS_FS is not set
# CONFIG_BFS_FS is not set
# CONFIG_EFS_FS is not set
# CONFIG_JFFS2_FS is not set
# CONFIG_UBIFS_FS is not set
CONFIG_CRAMFS=m
CONFIG_CRAMFS_BLOCKDEV=y
# CONFIG_CRAMFS_MTD is not set
CONFIG_SQUASHFS=m
CONFIG_SQUASHFS_FILE_CACHE=y
# CONFIG_SQUASHFS_FILE_DIRECT is not set
CONFIG_SQUASHFS_DECOMP_SINGLE=y
# CONFIG_SQUASHFS_DECOMP_MULTI is not set
# CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU is not set
CONFIG_SQUASHFS_XATTR=y
CONFIG_SQUASHFS_ZLIB=y
# CONFIG_SQUASHFS_LZ4 is not set
CONFIG_SQUASHFS_LZO=y
CONFIG_SQUASHFS_XZ=y
# CONFIG_SQUASHFS_ZSTD is not set
# CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
# CONFIG_VXFS_FS is not set
CONFIG_MINIX_FS=m
# CONFIG_OMFS_FS is not set
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
# CONFIG_QNX6FS_FS is not set
# CONFIG_ROMFS_FS is not set
CONFIG_PSTORE=y
CONFIG_PSTORE_DEFLATE_COMPRESS=y
# CONFIG_PSTORE_LZO_COMPRESS is not set
# CONFIG_PSTORE_LZ4_COMPRESS is not set
# CONFIG_PSTORE_LZ4HC_COMPRESS is not set
# CONFIG_PSTORE_842_COMPRESS is not set
# CONFIG_PSTORE_ZSTD_COMPRESS is not set
CONFIG_PSTORE_COMPRESS=y
CONFIG_PSTORE_DEFLATE_COMPRESS_DEFAULT=y
CONFIG_PSTORE_COMPRESS_DEFAULT="deflate"
CONFIG_PSTORE_CONSOLE=y
CONFIG_PSTORE_PMSG=y
# CONFIG_PSTORE_FTRACE is not set
CONFIG_PSTORE_RAM=m
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
# CONFIG_EROFS_FS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
# CONFIG_NFS_V2 is not set
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=m
# CONFIG_NFS_SWAP is not set
CONFIG_NFS_V4_1=y
CONFIG_NFS_V4_2=y
CONFIG_PNFS_FILE_LAYOUT=m
CONFIG_PNFS_BLOCK=m
CONFIG_PNFS_FLEXFILE_LAYOUT=m
CONFIG_NFS_V4_1_IMPLEMENTATION_ID_DOMAIN="kernel.org"
# CONFIG_NFS_V4_1_MIGRATION is not set
CONFIG_NFS_V4_SECURITY_LABEL=y
CONFIG_ROOT_NFS=y
# CONFIG_NFS_USE_LEGACY_DNS is not set
CONFIG_NFS_USE_KERNEL_DNS=y
CONFIG_NFS_DEBUG=y
CONFIG_NFS_DISABLE_UDP_SUPPORT=y
CONFIG_NFSD=m
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
CONFIG_NFSD_PNFS=y
# CONFIG_NFSD_BLOCKLAYOUT is not set
CONFIG_NFSD_SCSILAYOUT=y
# CONFIG_NFSD_FLEXFILELAYOUT is not set
# CONFIG_NFSD_V4_2_INTER_SSC is not set
CONFIG_NFSD_V4_SECURITY_LABEL=y
CONFIG_GRACE_PERIOD=y
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_NFS_ACL_SUPPORT=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=m
CONFIG_SUNRPC_BACKCHANNEL=y
CONFIG_RPCSEC_GSS_KRB5=m
# CONFIG_SUNRPC_DISABLE_INSECURE_ENCTYPES is not set
CONFIG_SUNRPC_DEBUG=y
CONFIG_SUNRPC_XPRT_RDMA=m
CONFIG_CEPH_FS=m
# CONFIG_CEPH_FSCACHE is not set
CONFIG_CEPH_FS_POSIX_ACL=y
# CONFIG_CEPH_FS_SECURITY_LABEL is not set
CONFIG_CIFS=m
# CONFIG_CIFS_STATS2 is not set
CONFIG_CIFS_ALLOW_INSECURE_LEGACY=y
CONFIG_CIFS_WEAK_PW_HASH=y
CONFIG_CIFS_UPCALL=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
CONFIG_CIFS_DEBUG=y
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_DEBUG_DUMP_KEYS is not set
CONFIG_CIFS_DFS_UPCALL=y
# CONFIG_CIFS_SMB_DIRECT is not set
# CONFIG_CIFS_FSCACHE is not set
# CONFIG_CODA_FS is not set
# CONFIG_AFS_FS is not set
CONFIG_9P_FS=y
CONFIG_9P_FS_POSIX_ACL=y
# CONFIG_9P_FS_SECURITY is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_MAC_ROMAN=m
CONFIG_NLS_MAC_CELTIC=m
CONFIG_NLS_MAC_CENTEURO=m
CONFIG_NLS_MAC_CROATIAN=m
CONFIG_NLS_MAC_CYRILLIC=m
CONFIG_NLS_MAC_GAELIC=m
CONFIG_NLS_MAC_GREEK=m
CONFIG_NLS_MAC_ICELAND=m
CONFIG_NLS_MAC_INUIT=m
CONFIG_NLS_MAC_ROMANIAN=m
CONFIG_NLS_MAC_TURKISH=m
CONFIG_NLS_UTF8=m
CONFIG_DLM=m
CONFIG_DLM_DEBUG=y
# CONFIG_UNICODE is not set
CONFIG_IO_WQ=y
# end of File systems

#
# Security options
#
CONFIG_KEYS=y
# CONFIG_KEYS_REQUEST_CACHE is not set
CONFIG_PERSISTENT_KEYRINGS=y
CONFIG_BIG_KEYS=y
CONFIG_TRUSTED_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
# CONFIG_KEY_DH_OPERATIONS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
CONFIG_PAGE_TABLE_ISOLATION=y
# CONFIG_SECURITY_INFINIBAND is not set
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_PATH=y
CONFIG_INTEL_TXT=y
CONFIG_LSM_MMAP_MIN_ADDR=65535
CONFIG_HAVE_HARDENED_USERCOPY_ALLOCATOR=y
CONFIG_HARDENED_USERCOPY=y
CONFIG_HARDENED_USERCOPY_FALLBACK=y
# CONFIG_HARDENED_USERCOPY_PAGESPAN is not set
# CONFIG_FORTIFY_SOURCE is not set
# CONFIG_STATIC_USERMODEHELPER is not set
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
# CONFIG_SECURITY_SELINUX_DISABLE is not set
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
CONFIG_SECURITY_SELINUX_SIDTAB_HASH_BITS=9
CONFIG_SECURITY_SELINUX_SID2STR_CACHE_SIZE=256
# CONFIG_SECURITY_SMACK is not set
# CONFIG_SECURITY_TOMOYO is not set
CONFIG_SECURITY_APPARMOR=y
CONFIG_SECURITY_APPARMOR_HASH=y
CONFIG_SECURITY_APPARMOR_HASH_DEFAULT=y
# CONFIG_SECURITY_APPARMOR_DEBUG is not set
# CONFIG_SECURITY_LOADPIN is not set
CONFIG_SECURITY_YAMA=y
# CONFIG_SECURITY_SAFESETID is not set
# CONFIG_SECURITY_LOCKDOWN_LSM is not set
# CONFIG_SECURITY_LANDLOCK is not set
CONFIG_INTEGRITY=y
CONFIG_INTEGRITY_SIGNATURE=y
CONFIG_INTEGRITY_ASYMMETRIC_KEYS=y
CONFIG_INTEGRITY_TRUSTED_KEYRING=y
# CONFIG_INTEGRITY_PLATFORM_KEYRING is not set
CONFIG_INTEGRITY_AUDIT=y
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_LSM_RULES=y
# CONFIG_IMA_TEMPLATE is not set
CONFIG_IMA_NG_TEMPLATE=y
# CONFIG_IMA_SIG_TEMPLATE is not set
CONFIG_IMA_DEFAULT_TEMPLATE="ima-ng"
CONFIG_IMA_DEFAULT_HASH_SHA1=y
# CONFIG_IMA_DEFAULT_HASH_SHA256 is not set
CONFIG_IMA_DEFAULT_HASH="sha1"
# CONFIG_IMA_WRITE_POLICY is not set
# CONFIG_IMA_READ_POLICY is not set
CONFIG_IMA_APPRAISE=y
# CONFIG_IMA_ARCH_POLICY is not set
# CONFIG_IMA_APPRAISE_BUILD_POLICY is not set
CONFIG_IMA_APPRAISE_BOOTPARAM=y
# CONFIG_IMA_APPRAISE_MODSIG is not set
CONFIG_IMA_TRUSTED_KEYRING=y
# CONFIG_IMA_BLACKLIST_KEYRING is not set
# CONFIG_IMA_LOAD_X509 is not set
CONFIG_IMA_MEASURE_ASYMMETRIC_KEYS=y
CONFIG_IMA_QUEUE_EARLY_BOOT_KEYS=y
CONFIG_EVM=y
CONFIG_EVM_ATTR_FSUUID=y
# CONFIG_EVM_ADD_XATTRS is not set
# CONFIG_EVM_LOAD_X509 is not set
CONFIG_DEFAULT_SECURITY_SELINUX=y
# CONFIG_DEFAULT_SECURITY_APPARMOR is not set
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_LSM="landlock,lockdown,yama,loadpin,safesetid,integrity,selinux,smack,tomoyo,apparmor"

#
# Kernel hardening options
#

#
# Memory initialization
#
CONFIG_INIT_STACK_NONE=y
# CONFIG_GCC_PLUGIN_STRUCTLEAK_USER is not set
# CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF is not set
# CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL is not set
# CONFIG_GCC_PLUGIN_STACKLEAK is not set
# CONFIG_INIT_ON_ALLOC_DEFAULT_ON is not set
# CONFIG_INIT_ON_FREE_DEFAULT_ON is not set
# end of Memory initialization
# end of Kernel hardening options
# end of Security options

CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_ASYNC_PQ=m
CONFIG_ASYNC_RAID6_RECOV=m
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_SKCIPHER=y
CONFIG_CRYPTO_SKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_RNG_DEFAULT=y
CONFIG_CRYPTO_AKCIPHER2=y
CONFIG_CRYPTO_AKCIPHER=y
CONFIG_CRYPTO_KPP2=y
CONFIG_CRYPTO_KPP=m
CONFIG_CRYPTO_ACOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=m
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_NULL2=y
CONFIG_CRYPTO_PCRYPT=m
CONFIG_CRYPTO_CRYPTD=m
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_TEST=m
CONFIG_CRYPTO_SIMD=m
CONFIG_CRYPTO_GLUE_HELPER_X86=m
CONFIG_CRYPTO_ENGINE=m

#
# Public-key cryptography
#
CONFIG_CRYPTO_RSA=y
CONFIG_CRYPTO_DH=m
CONFIG_CRYPTO_ECC=m
CONFIG_CRYPTO_ECDH=m
# CONFIG_CRYPTO_ECRDSA is not set
# CONFIG_CRYPTO_CURVE25519 is not set
# CONFIG_CRYPTO_CURVE25519_X86 is not set

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=y
# CONFIG_CRYPTO_CHACHA20POLY1305 is not set
# CONFIG_CRYPTO_AEGIS128 is not set
# CONFIG_CRYPTO_AEGIS128_AESNI_SSE2 is not set
CONFIG_CRYPTO_SEQIV=y
CONFIG_CRYPTO_ECHAINIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
# CONFIG_CRYPTO_CFB is not set
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=m
# CONFIG_CRYPTO_OFB is not set
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m
# CONFIG_CRYPTO_KEYWRAP is not set
# CONFIG_CRYPTO_NHPOLY1305_SSE2 is not set
# CONFIG_CRYPTO_NHPOLY1305_AVX2 is not set
# CONFIG_CRYPTO_ADIANTUM is not set
CONFIG_CRYPTO_ESSIV=m

#
# Hash modes
#
CONFIG_CRYPTO_CMAC=m
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m
CONFIG_CRYPTO_VMAC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_CRC32=m
CONFIG_CRYPTO_CRC32_PCLMUL=m
CONFIG_CRYPTO_XXHASH=m
CONFIG_CRYPTO_BLAKE2B=m
# CONFIG_CRYPTO_BLAKE2S is not set
# CONFIG_CRYPTO_BLAKE2S_X86 is not set
CONFIG_CRYPTO_CRCT10DIF=y
CONFIG_CRYPTO_CRCT10DIF_PCLMUL=m
CONFIG_CRYPTO_GHASH=y
# CONFIG_CRYPTO_POLY1305 is not set
# CONFIG_CRYPTO_POLY1305_X86_64 is not set
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD128=m
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA1_SSSE3=y
CONFIG_CRYPTO_SHA256_SSSE3=y
CONFIG_CRYPTO_SHA512_SSSE3=m
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=m
# CONFIG_CRYPTO_SHA3 is not set
# CONFIG_CRYPTO_SM3 is not set
# CONFIG_CRYPTO_STREEBOG is not set
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_WP512=m
CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
# CONFIG_CRYPTO_AES_TI is not set
CONFIG_CRYPTO_AES_NI_INTEL=m
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_BLOWFISH_X86_64=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAMELLIA_X86_64=m
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=m
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64=m
CONFIG_CRYPTO_CAST_COMMON=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST5_AVX_X86_64=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_CAST6_AVX_X86_64=m
CONFIG_CRYPTO_DES=m
# CONFIG_CRYPTO_DES3_EDE_X86_64 is not set
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
CONFIG_CRYPTO_SALSA20=m
# CONFIG_CRYPTO_CHACHA20 is not set
# CONFIG_CRYPTO_CHACHA20_X86_64 is not set
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_SERPENT_SSE2_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX_X86_64=m
CONFIG_CRYPTO_SERPENT_AVX2_X86_64=m
# CONFIG_CRYPTO_SM4 is not set
CONFIG_CRYPTO_TEA=m
CONFIG_CRYPTO_TWOFISH=m
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_X86_64=m
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=m
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_LZO=y
# CONFIG_CRYPTO_842 is not set
# CONFIG_CRYPTO_LZ4 is not set
# CONFIG_CRYPTO_LZ4HC is not set
# CONFIG_CRYPTO_ZSTD is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
CONFIG_CRYPTO_DRBG_MENU=y
CONFIG_CRYPTO_DRBG_HMAC=y
CONFIG_CRYPTO_DRBG_HASH=y
CONFIG_CRYPTO_DRBG_CTR=y
CONFIG_CRYPTO_DRBG=y
CONFIG_CRYPTO_JITTERENTROPY=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_USER_API_RNG=m
# CONFIG_CRYPTO_USER_API_AEAD is not set
# CONFIG_CRYPTO_STATS is not set
CONFIG_CRYPTO_HASH_INFO=y

#
# Crypto library routines
#
CONFIG_CRYPTO_LIB_AES=y
CONFIG_CRYPTO_LIB_ARC4=m
# CONFIG_CRYPTO_LIB_BLAKE2S is not set
# CONFIG_CRYPTO_LIB_CHACHA is not set
# CONFIG_CRYPTO_LIB_CURVE25519 is not set
CONFIG_CRYPTO_LIB_DES=m
CONFIG_CRYPTO_LIB_POLY1305_RSIZE=11
# CONFIG_CRYPTO_LIB_POLY1305 is not set
# CONFIG_CRYPTO_LIB_CHACHA20POLY1305 is not set
CONFIG_CRYPTO_LIB_SHA256=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=m
CONFIG_CRYPTO_DEV_PADLOCK_AES=m
CONFIG_CRYPTO_DEV_PADLOCK_SHA=m
# CONFIG_CRYPTO_DEV_ATMEL_ECC is not set
# CONFIG_CRYPTO_DEV_ATMEL_SHA204A is not set
CONFIG_CRYPTO_DEV_CCP=y
CONFIG_CRYPTO_DEV_CCP_DD=m
CONFIG_CRYPTO_DEV_SP_CCP=y
CONFIG_CRYPTO_DEV_CCP_CRYPTO=m
CONFIG_CRYPTO_DEV_SP_PSP=y
# CONFIG_CRYPTO_DEV_CCP_DEBUGFS is not set
CONFIG_CRYPTO_DEV_QAT=m
CONFIG_CRYPTO_DEV_QAT_DH895xCC=m
CONFIG_CRYPTO_DEV_QAT_C3XXX=m
CONFIG_CRYPTO_DEV_QAT_C62X=m
CONFIG_CRYPTO_DEV_QAT_DH895xCCVF=m
CONFIG_CRYPTO_DEV_QAT_C3XXXVF=m
CONFIG_CRYPTO_DEV_QAT_C62XVF=m
# CONFIG_CRYPTO_DEV_NITROX_CNN55XX is not set
CONFIG_CRYPTO_DEV_CHELSIO=m
CONFIG_CRYPTO_DEV_VIRTIO=m
# CONFIG_CRYPTO_DEV_SAFEXCEL is not set
# CONFIG_CRYPTO_DEV_AMLOGIC_GXL is not set
CONFIG_ASYMMETRIC_KEY_TYPE=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
# CONFIG_ASYMMETRIC_TPM_KEY_SUBTYPE is not set
CONFIG_X509_CERTIFICATE_PARSER=y
# CONFIG_PKCS8_PRIVATE_KEY_PARSER is not set
CONFIG_PKCS7_MESSAGE_PARSER=y
# CONFIG_PKCS7_TEST_KEY is not set
CONFIG_SIGNED_PE_FILE_VERIFICATION=y

#
# Certificates for signature checking
#
CONFIG_MODULE_SIG_KEY="certs/signing_key.pem"
CONFIG_SYSTEM_TRUSTED_KEYRING=y
CONFIG_SYSTEM_TRUSTED_KEYS=""
# CONFIG_SYSTEM_EXTRA_CERTIFICATE is not set
# CONFIG_SECONDARY_TRUSTED_KEYRING is not set
CONFIG_SYSTEM_BLACKLIST_KEYRING=y
CONFIG_SYSTEM_BLACKLIST_HASH_LIST=""
# end of Certificates for signature checking

CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=m
CONFIG_RAID6_PQ_BENCHMARK=y
# CONFIG_PACKING is not set
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_NET_UTILS=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_CORDIC=m
CONFIG_PRIME_NUMBERS=m
CONFIG_RATIONAL=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
CONFIG_ARCH_HAS_FAST_MULTIPLIER=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC64 is not set
# CONFIG_CRC4 is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=m
CONFIG_CRC8=m
CONFIG_XXHASH=y
# CONFIG_RANDOM32_SELFTEST is not set
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_LZ4_DECOMPRESS=y
CONFIG_ZSTD_COMPRESS=m
CONFIG_ZSTD_DECOMPRESS=m
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_DECOMPRESS_LZ4=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_ENC8=y
CONFIG_REED_SOLOMON_DEC8=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_BTREE=y
CONFIG_INTERVAL_TREE=y
CONFIG_XARRAY_MULTI=y
CONFIG_ASSOCIATIVE_ARRAY=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT_MAP=y
CONFIG_HAS_DMA=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_ARCH_HAS_FORCE_DMA_UNENCRYPTED=y
CONFIG_DMA_VIRT_OPS=y
CONFIG_SWIOTLB=y
CONFIG_DMA_CMA=y

#
# Default contiguous memory area size:
#
CONFIG_CMA_SIZE_MBYTES=200
CONFIG_CMA_SIZE_SEL_MBYTES=y
# CONFIG_CMA_SIZE_SEL_PERCENTAGE is not set
# CONFIG_CMA_SIZE_SEL_MIN is not set
# CONFIG_CMA_SIZE_SEL_MAX is not set
CONFIG_CMA_ALIGNMENT=8
# CONFIG_DMA_API_DEBUG is not set
CONFIG_SGL_ALLOC=y
CONFIG_IOMMU_HELPER=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_GLOB=y
# CONFIG_GLOB_SELFTEST is not set
CONFIG_NLATTR=y
CONFIG_CLZ_TAB=y
CONFIG_IRQ_POLL=y
CONFIG_MPILIB=y
CONFIG_SIGNATURE=y
CONFIG_DIMLIB=y
CONFIG_LIBXBC=y
CONFIG_OID_REGISTRY=y
CONFIG_UCS2_STRING=y
CONFIG_HAVE_GENERIC_VDSO=y
CONFIG_GENERIC_GETTIMEOFDAY=y
CONFIG_GENERIC_VDSO_TIME_NS=y
CONFIG_FONT_SUPPORT=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_SG_POOL=y
CONFIG_ARCH_HAS_PMEM_API=y
CONFIG_MEMREGION=y
CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE=y
CONFIG_ARCH_HAS_UACCESS_MCSAFE=y
CONFIG_ARCH_STACKWALK=y
CONFIG_SBITMAP=y
# CONFIG_STRING_SELFTEST is not set
# end of Library routines

#
# Kernel hacking
#

#
# printk and dmesg options
#
CONFIG_PRINTK_TIME=y
# CONFIG_PRINTK_CALLER is not set
CONFIG_CONSOLE_LOGLEVEL_DEFAULT=7
CONFIG_CONSOLE_LOGLEVEL_QUIET=4
CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
CONFIG_BOOT_PRINTK_DELAY=y
CONFIG_DYNAMIC_DEBUG=y
CONFIG_SYMBOLIC_ERRNAME=y
CONFIG_DEBUG_BUGVERBOSE=y
# end of printk and dmesg options

#
# Compile-time checks and compiler options
#
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_INFO_REDUCED=y
# CONFIG_DEBUG_INFO_SPLIT is not set
# CONFIG_DEBUG_INFO_DWARF4 is not set
# CONFIG_DEBUG_INFO_BTF is not set
# CONFIG_GDB_SCRIPTS is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
# CONFIG_HEADERS_INSTALL is not set
CONFIG_OPTIMIZE_INLINING=y
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_SECTION_MISMATCH_WARN_ONLY=y
CONFIG_STACK_VALIDATION=y
# CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
# end of Compile-time checks and compiler options

#
# Generic Kernel Debugging Instruments
#
CONFIG_MAGIC_SYSRQ=y
CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
CONFIG_MAGIC_SYSRQ_SERIAL=y
CONFIG_DEBUG_FS=y
CONFIG_HAVE_ARCH_KGDB=y
# CONFIG_KGDB is not set
CONFIG_ARCH_HAS_UBSAN_SANITIZE_ALL=y
# CONFIG_UBSAN is not set
CONFIG_UBSAN_ALIGNMENT=y
# end of Generic Kernel Debugging Instruments

CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_MISC=y

#
# Memory Debugging
#
# CONFIG_PAGE_EXTENSION is not set
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_PAGE_OWNER is not set
# CONFIG_PAGE_POISONING is not set
# CONFIG_DEBUG_PAGE_REF is not set
CONFIG_DEBUG_RODATA_TEST=y
CONFIG_GENERIC_PTDUMP=y
# CONFIG_PTDUMP_DEBUGFS is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
# CONFIG_DEBUG_KMEMLEAK is not set
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_SCHED_STACK_END_CHECK is not set
# CONFIG_DEBUG_VM is not set
CONFIG_ARCH_HAS_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_VIRTUAL is not set
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_MEMORY_NOTIFIER_ERROR_INJECT=m
# CONFIG_DEBUG_PER_CPU_MAPS is not set
CONFIG_HAVE_ARCH_KASAN=y
CONFIG_HAVE_ARCH_KASAN_VMALLOC=y
CONFIG_CC_HAS_KASAN_GENERIC=y
# CONFIG_KASAN is not set
CONFIG_KASAN_STACK=1
# end of Memory Debugging

CONFIG_DEBUG_SHIRQ=y

#
# Debug Oops, Lockups and Hangs
#
CONFIG_PANIC_ON_OOPS=y
CONFIG_PANIC_ON_OOPS_VALUE=1
CONFIG_PANIC_TIMEOUT=0
CONFIG_LOCKUP_DETECTOR=y
CONFIG_SOFTLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_HARDLOCKUP_DETECTOR_PERF=y
CONFIG_HARDLOCKUP_CHECK_TIMESTAMP=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
# CONFIG_DETECT_HUNG_TASK is not set
# CONFIG_WQ_WATCHDOG is not set
# end of Debug Oops, Lockups and Hangs

#
# Scheduler Debugging
#
CONFIG_SCHED_DEBUG=y
CONFIG_SCHED_INFO=y
CONFIG_SCHEDSTATS=y
# end of Scheduler Debugging

# CONFIG_DEBUG_TIMEKEEPING is not set

#
# Lock Debugging (spinlocks, mutexes, etc...)
#
CONFIG_LOCK_DEBUGGING_SUPPORT=y
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
# CONFIG_DEBUG_RWSEMS is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
CONFIG_DEBUG_ATOMIC_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_LOCK_TORTURE_TEST=m
CONFIG_WW_MUTEX_SELFTEST=m
# end of Lock Debugging (spinlocks, mutexes, etc...)

CONFIG_STACKTRACE=y
# CONFIG_WARN_ALL_UNSEEDED_RANDOM is not set
# CONFIG_DEBUG_KOBJECT is not set

#
# Debug kernel data structures
#
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_PLIST is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
# CONFIG_BUG_ON_DATA_CORRUPTION is not set
# end of Debug kernel data structures

# CONFIG_DEBUG_CREDENTIALS is not set

#
# RCU Debugging
#
CONFIG_TORTURE_TEST=m
CONFIG_RCU_PERF_TEST=m
CONFIG_RCU_TORTURE_TEST=m
CONFIG_RCU_CPU_STALL_TIMEOUT=60
# CONFIG_RCU_TRACE is not set
# CONFIG_RCU_EQS_DEBUG is not set
# end of RCU Debugging

# CONFIG_DEBUG_WQ_FORCE_RR_CPU is not set
# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
# CONFIG_CPU_HOTPLUG_STATE_CONTROL is not set
CONFIG_LATENCYTOP=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_HAVE_DYNAMIC_FTRACE_WITH_DIRECT_CALLS=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_BOOTTIME_TRACING=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS=y
CONFIG_FUNCTION_PROFILER=y
CONFIG_STACK_TRACER=y
# CONFIG_PREEMPTIRQ_EVENTS is not set
# CONFIG_IRQSOFF_TRACER is not set
CONFIG_SCHED_TRACER=y
CONFIG_HWLAT_TRACER=y
# CONFIG_MMIOTRACE is not set
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACER_SNAPSHOT=y
# CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP is not set
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_KPROBE_EVENTS=y
# CONFIG_KPROBE_EVENTS_ON_NOTRACE is not set
CONFIG_UPROBE_EVENTS=y
CONFIG_BPF_EVENTS=y
CONFIG_DYNAMIC_EVENTS=y
CONFIG_PROBE_EVENTS=y
# CONFIG_BPF_KPROBE_OVERRIDE is not set
CONFIG_FTRACE_MCOUNT_RECORD=y
CONFIG_TRACING_MAP=y
CONFIG_HIST_TRIGGERS=y
# CONFIG_TRACE_EVENT_INJECT is not set
# CONFIG_TRACEPOINT_BENCHMARK is not set
CONFIG_RING_BUFFER_BENCHMARK=m
# CONFIG_TRACE_EVAL_MAP_FILE is not set
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_RING_BUFFER_STARTUP_TEST is not set
# CONFIG_PREEMPTIRQ_DELAY_TEST is not set
# CONFIG_SYNTH_EVENT_GEN_TEST is not set
# CONFIG_KPROBE_EVENT_GEN_TEST is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_SAMPLES is not set
CONFIG_ARCH_HAS_DEVMEM_IS_ALLOWED=y
CONFIG_STRICT_DEVMEM=y
# CONFIG_IO_STRICT_DEVMEM is not set

#
# x86 Debugging
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_EARLY_PRINTK_USB=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
# CONFIG_EARLY_PRINTK_USB_XDBC is not set
# CONFIG_EFI_PGT_DUMP is not set
# CONFIG_DEBUG_WX is not set
CONFIG_DOUBLEFAULT=y
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_DEBUG is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_X86_DECODER_SELFTEST=y
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
# CONFIG_DEBUG_ENTRY is not set
# CONFIG_DEBUG_NMI_SELFTEST is not set
CONFIG_X86_DEBUG_FPU=y
# CONFIG_PUNIT_ATOM_DEBUG is not set
CONFIG_UNWINDER_ORC=y
# CONFIG_UNWINDER_FRAME_POINTER is not set
# CONFIG_UNWINDER_GUESS is not set
# end of x86 Debugging

#
# Kernel Testing and Coverage
#
# CONFIG_KUNIT is not set
CONFIG_NOTIFIER_ERROR_INJECTION=m
CONFIG_PM_NOTIFIER_ERROR_INJECT=m
# CONFIG_NETDEV_NOTIFIER_ERROR_INJECT is not set
CONFIG_FUNCTION_ERROR_INJECTION=y
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
# CONFIG_FAIL_PAGE_ALLOC is not set
CONFIG_FAIL_MAKE_REQUEST=y
# CONFIG_FAIL_IO_TIMEOUT is not set
# CONFIG_FAIL_FUTEX is not set
CONFIG_FAULT_INJECTION_DEBUG_FS=y
# CONFIG_FAIL_FUNCTION is not set
# CONFIG_FAIL_MMC_REQUEST is not set
CONFIG_ARCH_HAS_KCOV=y
CONFIG_CC_HAS_SANCOV_TRACE_PC=y
# CONFIG_KCOV is not set
CONFIG_RUNTIME_TESTING_MENU=y
# CONFIG_LKDTM is not set
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_TEST_SORT is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_RBTREE_TEST is not set
# CONFIG_REED_SOLOMON_TEST is not set
# CONFIG_INTERVAL_TREE_TEST is not set
# CONFIG_PERCPU_TEST is not set
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_ASYNC_RAID6_TEST is not set
# CONFIG_TEST_HEXDUMP is not set
# CONFIG_TEST_STRING_HELPERS is not set
CONFIG_TEST_STRSCPY=m
# CONFIG_TEST_KSTRTOX is not set
CONFIG_TEST_PRINTF=m
CONFIG_TEST_BITMAP=m
# CONFIG_TEST_BITFIELD is not set
# CONFIG_TEST_UUID is not set
# CONFIG_TEST_XARRAY is not set
# CONFIG_TEST_OVERFLOW is not set
# CONFIG_TEST_RHASHTABLE is not set
# CONFIG_TEST_HASH is not set
# CONFIG_TEST_IDA is not set
CONFIG_TEST_LKM=m
CONFIG_TEST_VMALLOC=m
CONFIG_TEST_USER_COPY=m
CONFIG_TEST_BPF=m
CONFIG_TEST_BLACKHOLE_DEV=m
# CONFIG_FIND_BIT_BENCHMARK is not set
CONFIG_TEST_FIRMWARE=m
CONFIG_TEST_SYSCTL=m
# CONFIG_TEST_UDELAY is not set
CONFIG_TEST_STATIC_KEYS=m
CONFIG_TEST_KMOD=m
# CONFIG_TEST_MEMCAT_P is not set
CONFIG_TEST_LIVEPATCH=m
# CONFIG_TEST_STACKINIT is not set
# CONFIG_TEST_MEMINIT is not set
# CONFIG_MEMTEST is not set
# CONFIG_HYPERV_TESTING is not set
# end of Kernel Testing and Coverage
# end of Kernel hacking

--lKbk9CFItQTD29wm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=job-script

#!/bin/sh

export_top_env()
{
	export suite='kernel-selftests'
	export testcase='kernel-selftests'
	export category='functional'
	export need_memory='2G'
	export need_cpu=2
	export kernel_cmdline='kvm-intel.unrestricted_guest=0'
	export job_origin='/lkp/lkp/.src-20200407-224849/allot/cyclic:p1:linux-devel:devel-hourly/lkp-skl-d01/kernel-selftests.yaml'
	export queue_cmdline_keys='branch
commit
queue_at_least_once'
	export queue='validate'
	export testbox='lkp-skl-d01'
	export tbox_group='lkp-skl-d01'
	export submit_id='5e8e6229ee27f7121ff30b55'
	export job_file='/lkp/jobs/scheduled/lkp-skl-d01/kernel-selftests-kselftests-01-ucode=0xd6-debian-x86_64-20191114.cgz-d9d464ccf68e19bf7d303022d873141b5e1f7219-20200409-4639-az56oh-3.yaml'
	export id='de225c730e9219affad74f0c8e797264427f4da8'
	export queuer_version='/lkp-src'
	export model='Skylake'
	export nr_cpu=8
	export memory='16G'
	export nr_hdd_partitions=1
	export hdd_partitions='/dev/disk/by-id/ata-WDC_WD10EZEX-75WN4A0_WD-WCC6Y2JD9SLU-part1'
	export swap_partitions='/dev/disk/by-id/ata-WDC_WD10EZEX-75WN4A0_WD-WCC6Y2JD9SLU-part3'
	export rootfs_partition='/dev/disk/by-id/ata-WDC_WD10EZEX-75WN4A0_WD-WCC6Y2JD9SLU-part2'
	export brand='Intel(R) Core(TM) i7-6700 CPU @ 3.40GHz'
	export cpu_info='skylake i7-6700'
	export bios_version='1.2.8'
	export commit='d9d464ccf68e19bf7d303022d873141b5e1f7219'
	export need_kconfig_hw='CONFIG_E1000E=y
CONFIG_SATA_AHCI'
	export ucode='0xd6'
	export need_kernel_headers=true
	export need_kernel_selftests=true
	export need_kconfig='CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_DRM_DEBUG_SELFTEST=m ~ v(4\.1[8-9]|4\.20|5\.)
CONFIG_EMBEDDED=y
CONFIG_EXPERT=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_MOCKUP=y
CONFIG_HIST_TRIGGERS=y
CONFIG_IR_IMON_DECODER=m ~ v(4\.1[7-9]|4\.20|5\.)
CONFIG_IR_SHARP_DECODER=m
CONFIG_LIRC=y
CONFIG_TEST_BITMAP
CONFIG_TEST_PRINTF
CONFIG_TEST_STRSCPY=m ~ v(5\.2$|5\.[3-9])
CONFIG_WW_MUTEX_SELFTEST=m ~ v(4\.1[1-9]|4\.20|5\.)'
	export kconfig='x86_64-rhel-7.6'
	export compiler='gcc-7'
	export enqueue_time='2020-04-09 07:45:49 +0800'
	export _id='5e8e622dee27f7121ff30b57'
	export _rt='/result/kernel-selftests/kselftests-01-ucode=0xd6/lkp-skl-d01/debian-x86_64-20191114.cgz/x86_64-rhel-7.6/gcc-7/d9d464ccf68e19bf7d303022d873141b5e1f7219'
	export user='lkp'
	export head_commit='dc72e287c044cd82644b009e72545e3f5e8d7699'
	export base_commit='7111951b8d4973bda27ff663f2cf18b663d15b48'
	export branch='linux-devel/devel-hourly-2020040801'
	export rootfs='debian-x86_64-20191114.cgz'
	export result_root='/result/kernel-selftests/kselftests-01-ucode=0xd6/lkp-skl-d01/debian-x86_64-20191114.cgz/x86_64-rhel-7.6/gcc-7/d9d464ccf68e19bf7d303022d873141b5e1f7219/3'
	export scheduler_version='/lkp/lkp/.src-20200408-145327'
	export LKP_SERVER='inn'
	export arch='x86_64'
	export max_uptime=3600
	export initrd='/osimage/debian/debian-x86_64-20191114.cgz'
	export bootloader_append='root=/dev/ram0
user=lkp
job=/lkp/jobs/scheduled/lkp-skl-d01/kernel-selftests-kselftests-01-ucode=0xd6-debian-x86_64-20191114.cgz-d9d464ccf68e19bf7d303022d873141b5e1f7219-20200409-4639-az56oh-3.yaml
ARCH=x86_64
kconfig=x86_64-rhel-7.6
branch=linux-devel/devel-hourly-2020040801
commit=d9d464ccf68e19bf7d303022d873141b5e1f7219
BOOT_IMAGE=/pkg/linux/x86_64-rhel-7.6/gcc-7/d9d464ccf68e19bf7d303022d873141b5e1f7219/vmlinuz-5.6.0-rc1-00033-gd9d464ccf68e1
kvm-intel.unrestricted_guest=0
max_uptime=3600
RESULT_ROOT=/result/kernel-selftests/kselftests-01-ucode=0xd6/lkp-skl-d01/debian-x86_64-20191114.cgz/x86_64-rhel-7.6/gcc-7/d9d464ccf68e19bf7d303022d873141b5e1f7219/3
LKP_SERVER=inn
nokaslr
selinux=0
debug
apic=debug
sysrq_always_enabled
rcupdate.rcu_cpu_stall_timeout=100
net.ifnames=0
printk.devkmsg=on
panic=-1
softlockup_panic=1
nmi_watchdog=panic
oops=panic
load_ramdisk=2
prompt_ramdisk=0
drbd.minor_count=8
systemd.log_level=err
ignore_loglevel
console=tty0
earlyprintk=ttyS0,115200
console=ttyS0,115200
vga=normal
rw'
	export modules_initrd='/pkg/linux/x86_64-rhel-7.6/gcc-7/d9d464ccf68e19bf7d303022d873141b5e1f7219/modules.cgz'
	export bm_initrd='/osimage/deps/debian-x86_64-20180403.cgz/run-ipconfig_2018-04-03.cgz,/osimage/deps/debian-x86_64-20180403.cgz/lkp_2019-08-05.cgz,/osimage/deps/debian-x86_64-20180403.cgz/rsync-rootfs_2018-04-03.cgz,/osimage/deps/debian-x86_64-20180403.cgz/kernel-selftests_20200402.cgz,/osimage/pkg/debian-x86_64-20180403.cgz/kernel-selftests-x86_64-5a3faf29-1_20200331.cgz,/osimage/deps/debian-x86_64-20180403.cgz/hw_2020-01-02.cgz'
	export linux_headers_initrd='/pkg/linux/x86_64-rhel-7.6/gcc-7/d9d464ccf68e19bf7d303022d873141b5e1f7219/linux-headers.cgz'
	export linux_selftests_initrd='/pkg/linux/x86_64-rhel-7.6/gcc-7/d9d464ccf68e19bf7d303022d873141b5e1f7219/linux-selftests.cgz'
	export lkp_initrd='/osimage/user/lkp/lkp-x86_64.cgz'
	export site='inn'
	export LKP_CGI_PORT=80
	export LKP_CIFS_PORT=139
	export last_kernel='4.20.0'
	export repeat_to=4
	export schedule_notify_address=
	export queue_at_least_once=1
	export kernel='/pkg/linux/x86_64-rhel-7.6/gcc-7/d9d464ccf68e19bf7d303022d873141b5e1f7219/vmlinuz-5.6.0-rc1-00033-gd9d464ccf68e1'
	export dequeue_time='2020-04-09 08:12:24 +0800'
	export job_initrd='/lkp/jobs/scheduled/lkp-skl-d01/kernel-selftests-kselftests-01-ucode=0xd6-debian-x86_64-20191114.cgz-d9d464ccf68e19bf7d303022d873141b5e1f7219-20200409-4639-az56oh-3.cgz'

	[ -n "$LKP_SRC" ] ||
	export LKP_SRC=/lkp/${user:-lkp}/src
}

run_job()
{
	echo $$ > $TMP/run-job.pid

	. $LKP_SRC/lib/http.sh
	. $LKP_SRC/lib/job.sh
	. $LKP_SRC/lib/env.sh

	export_top_env

	run_monitor $LKP_SRC/monitors/wrapper kmsg
	run_monitor $LKP_SRC/monitors/wrapper heartbeat
	run_monitor $LKP_SRC/monitors/wrapper meminfo
	run_monitor $LKP_SRC/monitors/wrapper oom-killer
	run_monitor $LKP_SRC/monitors/plain/watchdog

	run_test group='kselftests-01' $LKP_SRC/tests/wrapper kernel-selftests
}

extract_stats()
{
	export stats_part_begin=
	export stats_part_end=

	$LKP_SRC/stats/wrapper kernel-selftests
	$LKP_SRC/stats/wrapper kmsg
	$LKP_SRC/stats/wrapper meminfo

	$LKP_SRC/stats/wrapper time kernel-selftests.time
	$LKP_SRC/stats/wrapper dmesg
	$LKP_SRC/stats/wrapper kmsg
	$LKP_SRC/stats/wrapper last_state
	$LKP_SRC/stats/wrapper stderr
	$LKP_SRC/stats/wrapper time
}

"$@"

--lKbk9CFItQTD29wm
Content-Type: application/x-xz
Content-Disposition: attachment; filename="dmesg.xz"
Content-Transfer-Encoding: base64

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

--lKbk9CFItQTD29wm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=kernel-selftests
Content-Transfer-Encoding: quoted-printable

KERNEL SELFTESTS: linux_headers_dir is /usr/src/linux-headers-x86_64-rhel-7=
=2E6-d9d464ccf68e19bf7d303022d873141b5e1f7219
2020-04-09 08:13:13 ln -sf /usr/bin/clang
2020-04-09 08:13:13 ln -sf /usr/bin/llc
2020-04-09 08:13:13 sed -i s/default_timeout=3D45/default_timeout=3D300/ ks=
elftest/runner.sh
2020-04-09 08:13:13 make run_tests -C capabilities
make: Entering directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf=
68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/capabilities'
gcc -O2 -g -std=3Dgnu99 -Wall    test_execve.c /usr/src/perf_selftests-x86_=
64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftest=
s/kselftest_harness.h /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e1=
9bf7d303022d873141b5e1f7219/tools/testing/selftests/kselftest.h -lcap-ng -l=
rt -ldl -o /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022=
d873141b5e1f7219/tools/testing/selftests/capabilities/test_execve
gcc -O2 -g -std=3Dgnu99 -Wall    validate_cap.c /usr/src/perf_selftests-x86=
_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftes=
ts/kselftest_harness.h /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/kselftest.h -lcap-ng -=
lrt -ldl -o /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d30302=
2d873141b5e1f7219/tools/testing/selftests/capabilities/validate_cap
TAP version 13
1..1
# selftests: capabilities: test_execve
# # validate_cap:: Capabilities after execve were correct
# # validate_cap:: Capabilities after execve were correct
# # validate_cap:: Capabilities after execve were correct
# # validate_cap:: Capabilities after execve were correct
# # validate_cap:: Capabilities after execve were correct
# # validate_cap:: Capabilities after execve were correct
# # validate_cap:: Capabilities after execve were correct
# # validate_cap:: Capabilities after execve were correct
# TAP version 13
# 1..12
# # [RUN]	+++ Tests with uid =3D=3D 0 +++
# # [NOTE]	Using global UIDs for tests
# # [RUN]	Root =3D> ep
# ok 1 Passed
# # Check cap_ambient manipulation rules
# ok 2 PR_CAP_AMBIENT_RAISE failed on non-inheritable cap
# ok 3 PR_CAP_AMBIENT_RAISE failed on non-permitted cap
# ok 4 PR_CAP_AMBIENT_RAISE worked
# ok 5 Basic manipulation appears to work
# # [RUN]	Root +i =3D> eip
# ok 6 Passed
# # [RUN]	UID 0 +ia =3D> eipa
# ok 7 Passed
# # [RUN]	Root +ia, suidroot =3D> eipa
# ok 8 Passed
# # [RUN]	Root +ia, suidnonroot =3D> ip
# ok 9 Passed
# # [RUN]	Root +ia, sgidroot =3D> eipa
# ok 10 Passed
# ok 11 Passed
# # [RUN]	Root +ia, sgidnonroot =3D> eip
# ok 12 Passed
# # Pass 12 Fail 0 Xfail 0 Xpass 0 Skip 0 Error 0
# # validate_cap:: Capabilities after execve were correct
# # validate_cap:: Capabilities after execve were correct
# # validate_cap:: Capabilities after execve were correct
# # validate_cap:: Capabilities after execve were correct
# # validate_cap:: Capabilities after execve were correct
# # =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
# TAP version 13
# 1..9
# # [RUN]	+++ Tests with uid !=3D 0 +++
# # [NOTE]	Using global UIDs for tests
# # [RUN]	Non-root =3D> no caps
# ok 1 Passed
# # Check cap_ambient manipulation rules
# ok 2 PR_CAP_AMBIENT_RAISE failed on non-inheritable cap
# ok 3 PR_CAP_AMBIENT_RAISE failed on non-permitted cap
# ok 4 PR_CAP_AMBIENT_RAISE worked
# ok 5 Basic manipulation appears to work
# # [RUN]	Non-root +i =3D> i
# ok 6 Passed
# # [RUN]	UID 1 +ia =3D> eipa
# ok 7 Passed
# # [RUN]	Non-root +ia, sgidnonroot =3D> i
# ok 8 Passed
# ok 9 Passed
# # Pass 9 Fail 0 Xfail 0 Xpass 0 Skip 0 Error 0
# # =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
ok 1 selftests: capabilities: test_execve
make: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf6=
8e19bf7d303022d873141b5e1f7219/tools/testing/selftests/capabilities'
ignored_by_lkp cgroup test
2020-04-09 08:13:14 make run_tests -C clone3
make: Entering directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf=
68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/clone3'
gcc -g -I../../../../usr/include/    clone3.c /usr/src/perf_selftests-x86_6=
4-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests=
/kselftest_harness.h /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19=
bf7d303022d873141b5e1f7219/tools/testing/selftests/kselftest.h  -o /usr/src=
/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/to=
ols/testing/selftests/clone3/clone3
gcc -g -I../../../../usr/include/    clone3_clear_sighand.c /usr/src/perf_s=
elftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/tes=
ting/selftests/kselftest_harness.h /usr/src/perf_selftests-x86_64-rhel-7.6-=
d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kselftest.=
h  -o /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d8731=
41b5e1f7219/tools/testing/selftests/clone3/clone3_clear_sighand
gcc -g -I../../../../usr/include/    clone3_set_tid.c /usr/src/perf_selftes=
ts-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/s=
elftests/kselftest_harness.h /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464=
ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kselftest.h  -o =
/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1=
f7219/tools/testing/selftests/clone3/clone3_set_tid
TAP version 13
1..3
# selftests: clone3: clone3
# # clone3() syscall supported
# TAP version 13
# 1..17
# # [1435] Trying clone3() with flags 0 (size 0)
# # I am the parent (1435). My child's pid is 1436
# # [1435] clone3() with flags says: 0 expected 0
# ok 1 [1435] Result (0) matches expectation (0)
# # [1435] Trying clone3() with flags 0x20000000 (size 0)
# # I am the parent (1435). My child's pid is 1437
# # [1435] clone3() with flags says: 0 expected 0
# ok 2 [1435] Result (0) matches expectation (0)
# # [1435] Trying clone3() with flags 0 (size 64)
# # I am the parent (1435). My child's pid is 1438
# # [1435] clone3() with flags says: 0 expected 0
# ok 3 [1435] Result (0) matches expectation (0)
# # [1435] Trying clone3() with flags 0 (size 56)
# # Invalid argument - Failed to create new process
# # [1435] clone3() with flags says: -22 expected -22
# ok 4 [1435] Result (-22) matches expectation (-22)
# # [1435] Trying clone3() with flags 0 (size 88)
# # I am the parent (1435). My child's pid is 1439
# # [1435] clone3() with flags says: 0 expected 0
# ok 5 [1435] Result (0) matches expectation (0)
# # [1435] Trying clone3() with flags 0 (size 0)
# # Invalid argument - Failed to create new process
# # [1435] clone3() with flags says: -22 expected -22
# ok 6 [1435] Result (-22) matches expectation (-22)
# # [1435] Trying clone3() with flags 0 (size 0)
# # Invalid argument - Failed to create new process
# # [1435] clone3() with flags says: -22 expected -22
# ok 7 [1435] Result (-22) matches expectation (-22)
# # [1435] Trying clone3() with flags 0 (size 0)
# # Invalid argument - Failed to create new process
# # [1435] clone3() with flags says: -22 expected -22
# ok 8 [1435] Result (-22) matches expectation (-22)
# # [1435] Trying clone3() with flags 0 (size 0)
# # Invalid argument - Failed to create new process
# # [1435] clone3() with flags says: -22 expected -22
# ok 9 [1435] Result (-22) matches expectation (-22)
# # [1435] Trying clone3() with flags 0 (size 88)
# # I am the parent (1435). My child's pid is 1440
# # [1435] clone3() with flags says: 0 expected 0
# ok 10 [1435] Result (0) matches expectation (0)
# # [1435] Trying clone3() with flags 0 (size 96)
# # Argument list too long - Failed to create new process
# # [1435] clone3() with flags says: -7 expected -7
# ok 11 [1435] Result (-7) matches expectation (-7)
# # [1435] Trying clone3() with flags 0 (size 160)
# # Argument list too long - Failed to create new process
# # [1435] clone3() with flags says: -7 expected -7
# ok 12 [1435] Result (-7) matches expectation (-7)
# # [1435] Trying clone3() with flags 0 (size 4104)
# # Argument list too long - Failed to create new process
# # [1435] clone3() with flags says: -7 expected -7
# ok 13 [1435] Result (-7) matches expectation (-7)
# # [1435] Trying clone3() with flags 0x20000000 (size 64)
# # I am the parent (1435). My child's pid is 1441
# # [1435] clone3() with flags says: 0 expected 0
# ok 14 [1435] Result (0) matches expectation (0)
# # [1435] Trying clone3() with flags 0x20000000 (size 56)
# # Invalid argument - Failed to create new process
# # [1435] clone3() with flags says: -22 expected -22
# ok 15 [1435] Result (-22) matches expectation (-22)
# # [1435] Trying clone3() with flags 0x20000000 (size 88)
# # I am the parent (1435). My child's pid is 1442
# # [1435] clone3() with flags says: 0 expected 0
# ok 16 [1435] Result (0) matches expectation (0)
# # [1435] Trying clone3() with flags 0x20000000 (size 4104)
# # Argument list too long - Failed to create new process
# # [1435] clone3() with flags says: -7 expected -7
# ok 17 [1435] Result (-7) matches expectation (-7)
# # Pass 17 Fail 0 Xfail 0 Xpass 0 Skip 0 Error 0
ok 1 selftests: clone3: clone3
# selftests: clone3: clone3_clear_sighand
# TAP version 13
# # clone3() syscall supported
# 1..1
# ok 1 Cleared signal handlers for child process
# # Pass 1 Fail 0 Xfail 0 Xpass 0 Skip 0 Error 0
ok 2 selftests: clone3: clone3_clear_sighand
# selftests: clone3: clone3_set_tid
# TAP version 13
# # clone3() syscall supported
# 1..29
# # /proc/sys/kernel/pid_max 32768
# # [1467] Trying clone3() with CLONE_SET_TID to 0 and 0x0
# # Invalid argument - Failed to create new process
# # [1467] clone3() with CLONE_SET_TID 0 says :-22 - expected -22
# ok 1 [1467] Result (-22) matches expectation (-22)
# # [1467] Trying clone3() with CLONE_SET_TID to 0 and 0x0
# # Invalid argument - Failed to create new process
# # [1467] clone3() with CLONE_SET_TID 0 says :-22 - expected -22
# ok 2 [1467] Result (-22) matches expectation (-22)
# # [1467] Trying clone3() with CLONE_SET_TID to 0 and 0x0
# # Invalid argument - Failed to create new process
# # [1467] clone3() with CLONE_SET_TID 0 says :-22 - expected -22
# ok 3 [1467] Result (-22) matches expectation (-22)
# # [1467] Trying clone3() with CLONE_SET_TID to 0 and 0x0
# # Invalid argument - Failed to create new process
# # [1467] clone3() with CLONE_SET_TID 0 says :-22 - expected -22
# ok 4 [1467] Result (-22) matches expectation (-22)
# # [1467] Trying clone3() with CLONE_SET_TID to 0 and 0x0
# # Invalid argument - Failed to create new process
# # [1467] clone3() with CLONE_SET_TID 0 says :-22 - expected -22
# ok 5 [1467] Result (-22) matches expectation (-22)
# # [1467] Trying clone3() with CLONE_SET_TID to -1 and 0x0
# # Invalid argument - Failed to create new process
# # [1467] clone3() with CLONE_SET_TID -1 says :-22 - expected -22
# ok 6 [1467] Result (-22) matches expectation (-22)
# # [1467] Trying clone3() with CLONE_SET_TID to -1 and 0x0
# # Invalid argument - Failed to create new process
# # [1467] clone3() with CLONE_SET_TID -1 says :-22 - expected -22
# ok 7 [1467] Result (-22) matches expectation (-22)
# # [1467] Trying clone3() with CLONE_SET_TID to -1 and 0x0
# # Invalid argument - Failed to create new process
# # [1467] clone3() with CLONE_SET_TID -1 says :-22 - expected -22
# ok 8 [1467] Result (-22) matches expectation (-22)
# # [1467] Trying clone3() with CLONE_SET_TID to -1 and 0x0
# # Invalid argument - Failed to create new process
# # [1467] clone3() with CLONE_SET_TID -1 says :-22 - expected -22
# ok 9 [1467] Result (-22) matches expectation (-22)
# # [1467] Trying clone3() with CLONE_SET_TID to -1 and 0x0
# # Invalid argument - Failed to create new process
# # [1467] clone3() with CLONE_SET_TID -1 says :-22 - expected -22
# ok 10 [1467] Result (-22) matches expectation (-22)
# # [1467] Trying clone3() with CLONE_SET_TID to 0 and 0x0
# # Invalid argument - Failed to create new process
# # [1467] clone3() with CLONE_SET_TID 0 says :-22 - expected -22
# ok 11 [1467] Result (-22) matches expectation (-22)
# # [1467] Trying clone3() with CLONE_SET_TID to -1 and 0x0
# # Invalid argument - Failed to create new process
# # [1467] clone3() with CLONE_SET_TID -1 says :-22 - expected -22
# ok 12 [1467] Result (-22) matches expectation (-22)
# # [1467] Trying clone3() with CLONE_SET_TID to -1 and 0x0
# # Invalid argument - Failed to create new process
# # [1467] clone3() with CLONE_SET_TID -1 says :-22 - expected -22
# ok 13 [1467] Result (-22) matches expectation (-22)
# # [1467] Trying clone3() with CLONE_SET_TID to -1 and 0x20000000
# # Invalid argument - Failed to create new process
# # [1467] clone3() with CLONE_SET_TID -1 says :-22 - expected -22
# ok 14 [1467] Result (-22) matches expectation (-22)
# # [1467] Trying clone3() with CLONE_SET_TID to 1 and 0x0
# # File exists - Failed to create new process
# # [1467] clone3() with CLONE_SET_TID 1 says :-17 - expected -17
# ok 15 [1467] Result (-17) matches expectation (-17)
# # [1467] Trying clone3() with CLONE_SET_TID to 1 and 0x20000000
# # I am the child, my PID is 1 (expected 1)
# # I am the parent (1467). My child's pid is 1468
# # [1467] clone3() with CLONE_SET_TID 1 says :0 - expected 0
# ok 16 [1467] Result (0) matches expectation (0)
# # [1467] Trying clone3() with CLONE_SET_TID to 32768 and 0x0
# # Invalid argument - Failed to create new process
# # [1467] clone3() with CLONE_SET_TID 32768 says :-22 - expected -22
# ok 17 [1467] Result (-22) matches expectation (-22)
# # [1467] Trying clone3() with CLONE_SET_TID to 32768 and 0x20000000
# # Invalid argument - Failed to create new process
# # [1467] clone3() with CLONE_SET_TID 32768 says :-22 - expected -22
# ok 18 [1467] Result (-22) matches expectation (-22)
# # Child has PID 1469
# # Invalid argument - Failed to create new process
# # [1467] clone3() with CLONE_SET_TID 32768 says :-22 - expected -22
# ok 18 [1467] Result (-22) matches expectation (-22)
# # [1467] Trying clone3() with CLONE_SET_TID to 1469 and 0x0
# # I am the child, my PID is 1469 (expected 1469)
# # I am the parent (1467). My child's pid is 1469
# # [1467] clone3() with CLONE_SET_TID 1469 says :0 - expected 0
# ok 19 [1467] Result (0) matches expectation (0)
# # [1467] Trying clone3() with CLONE_SET_TID to 1469 and 0x20000000
# # Invalid argument - Failed to create new process
# # [1467] clone3() with CLONE_SET_TID 1469 says :-22 - expected -22
# ok 20 [1467] Result (-22) matches expectation (-22)
# # [1467] Trying clone3() with CLONE_SET_TID to 1 and 0x20000000
# # I am the child, my PID is 1 (expected 1)
# # I am the parent (1467). My child's pid is 1469
# # [1467] clone3() with CLONE_SET_TID 1 says :0 - expected 0
# ok 21 [1467] Result (0) matches expectation (0)
# # unshare PID namespace
# # [1467] Trying clone3() with CLONE_SET_TID to 1469 and 0x0
# # Invalid argument - Failed to create new process
# # [1467] clone3() with CLONE_SET_TID 1469 says :-22 - expected -22
# ok 22 [1467] Result (-22) matches expectation (-22)
# # [1] Trying clone3() with CLONE_SET_TID to 43 and 0x0
# # Invalid argument - Failed to create new process
# # [1] clone3() with CLONE_SET_TID 43 says :-22 - expected -22
# ok 23 [1] Result (-22) matches expectation (-22)
# # [1] Trying clone3() with CLONE_SET_TID to 43 and 0x0
# # I am the child, my PID is 43 (expected 43)
# # I am the parent (1). My child's pid is 43
# # [1] clone3() with CLONE_SET_TID 43 says :0 - expected 0
# ok 24 [1] Result (0) matches expectation (0)
# # Child in PID namespace has PID 1
# # [1] Trying clone3() with CLONE_SET_TID to 2 and 0x0
# # I am the child, my PID is 2 (expected 2)
# # I am the parent (1). My child's pid is 2
# # [1] clone3() with CLONE_SET_TID 2 says :0 - expected 0
# ok 25 [1] Result (0) matches expectation (0)
# # [1] Trying clone3() with CLONE_SET_TID to 1 and 0x20000000
# # Invalid argument - Failed to create new process
# # [1] clone3() with CLONE_SET_TID 1 says :-22 - expected -22
# ok 26 [1] Result (-22) matches expectation (-22)
# # [1] Trying clone3() with CLONE_SET_TID to 1 and 0x20000000
# # Invalid argument - Failed to create new process
# # [1] clone3() with CLONE_SET_TID 1 says :-22 - expected -22
# ok 27 [1] Result (-22) matches expectation (-22)
# # [1] Trying clone3() with CLONE_SET_TID to 1 and 0x20000000
# # I am the child, my PID is 1 (expected 1)
# # [1] Child is ready and waiting
# # I am the parent (1). My child's pid is 42
# # [1] clone3() with CLONE_SET_TID 1 says :0 - expected 0
# ok 28 [1] Result (0) matches expectation (0)
# # Invalid argument - Failed to create new process
# # [1467] clone3() with CLONE_SET_TID 1469 says :-22 - expected -22
# ok 22 [1467] Result (-22) matches expectation (-22)
# # [1467] Child is ready and waiting
# ok 29 PIDs in all namespaces as expected (1469,42,1)
# # Pass 29 Fail 0 Xfail 0 Xpass 0 Skip 0 Error 0
ok 3 selftests: clone3: clone3_set_tid
make: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf6=
8e19bf7d303022d873141b5e1f7219/tools/testing/selftests/clone3'
2020-04-09 08:13:14 make run_tests -C cpu-hotplug
make: Entering directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf=
68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/cpu-hotplug'
TAP version 13
1..1
# selftests: cpu-hotplug: cpu-on-off-test.sh
# pid 1515's current affinity mask: ff
# pid 1515's new affinity mask: 1
# CPU online/offline summary:
# present_cpus =3D 0-7 present_max =3D 7
# 	 Cpus in online state: 0-7
# 	 Cpus in offline state: 0
# Limited scope test: one hotplug cpu
# 	 (leaves cpu in the original state):
# 	 online to offline to online: cpu 7
ok 1 selftests: cpu-hotplug: cpu-on-off-test.sh
make: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf6=
8e19bf7d303022d873141b5e1f7219/tools/testing/selftests/cpu-hotplug'
2020-04-09 08:13:14 make run_tests -C cpufreq
make: Entering directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf=
68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/cpufreq'
TAP version 13
1..1
# selftests: cpufreq: main.sh
# pid 1576's current affinity mask: ff
# pid 1576's new affinity mask: 1
# cat: /sys/devices/system/cpu/cpufreq/policy0/scaling_governor: Invalid ar=
gument
# cat: /sys/devices/system/cpu/cpufreq/policy1/scaling_governor: Invalid ar=
gument
# cat: /sys/devices/system/cpu/cpufreq/policy2/scaling_governor: Invalid ar=
gument
# cat: /sys/devices/system/cpu/cpufreq/policy3/scaling_governor: Invalid ar=
gument
# cat: /sys/devices/system/cpu/cpufreq/policy4/scaling_governor: Invalid ar=
gument
# cat: /sys/devices/system/cpu/cpufreq/policy5/scaling_governor: Invalid ar=
gument
# cat: /sys/devices/system/cpu/cpufreq/policy6/scaling_governor: Invalid ar=
gument
# cat: /sys/devices/system/cpu/cpufreq/policy7/scaling_governor: Invalid ar=
gument
# cat: /sys/devices/system/cpu/cpufreq/policy0/scaling_governor: Invalid ar=
gument
# cpufreq.sh: line 95: echo: write error: Invalid argument
# cat: /sys/devices/system/cpu/cpufreq/policy1/scaling_governor: Invalid ar=
gument
# cpufreq.sh: line 95: echo: write error: Invalid argument
# cat: /sys/devices/system/cpu/cpufreq/policy2/scaling_governor: Invalid ar=
gument
# cpufreq.sh: line 95: echo: write error: Invalid argument
# cat: /sys/devices/system/cpu/cpufreq/policy3/scaling_governor: Invalid ar=
gument
# cpufreq.sh: line 95: echo: write error: Invalid argument
# cat: /sys/devices/system/cpu/cpufreq/policy4/scaling_governor: Invalid ar=
gument
# cpufreq.sh: line 95: echo: write error: Invalid argument
# cat: /sys/devices/system/cpu/cpufreq/policy5/scaling_governor: Invalid ar=
gument
# cpufreq.sh: line 95: echo: write error: Invalid argument
# cat: /sys/devices/system/cpu/cpufreq/policy6/scaling_governor: Invalid ar=
gument
# cpufreq.sh: line 95: echo: write error: Invalid argument
# cat: /sys/devices/system/cpu/cpufreq/policy7/scaling_governor: Invalid ar=
gument
# cpufreq.sh: line 95: echo: write error: Invalid argument
# cat: /sys/devices/system/cpu/cpufreq/policy0/scaling_governor: Invalid ar=
gument
# governor.sh: line 45: [: =3D=3D: unary operator expected
# cat: /sys/devices/system/cpu/cpufreq/policy1/scaling_governor: Invalid ar=
gument
# governor.sh: line 45: [: =3D=3D: unary operator expected
# cat: /sys/devices/system/cpu/cpufreq/policy2/scaling_governor: Invalid ar=
gument
# governor.sh: line 45: [: =3D=3D: unary operator expected
# cat: /sys/devices/system/cpu/cpufreq/policy3/scaling_governor: Invalid ar=
gument
# governor.sh: line 45: [: =3D=3D: unary operator expected
# cat: /sys/devices/system/cpu/cpufreq/policy4/scaling_governor: Invalid ar=
gument
# governor.sh: line 45: [: =3D=3D: unary operator expected
# cat: /sys/devices/system/cpu/cpufreq/policy5/scaling_governor: Invalid ar=
gument
# governor.sh: line 45: [: =3D=3D: unary operator expected
# cat: /sys/devices/system/cpu/cpufreq/policy6/scaling_governor: Invalid ar=
gument
# governor.sh: line 45: [: =3D=3D: unary operator expected
# cat: /sys/devices/system/cpu/cpufreq/policy7/scaling_governor: Invalid ar=
gument
# governor.sh: line 45: [: =3D=3D: unary operator expected
# cat: /sys/devices/system/cpu/cpufreq/policy0/scaling_governor: Invalid ar=
gument
# governor.sh: line 45: [: =3D=3D: unary operator expected
# cat: /sys/devices/system/cpu/cpufreq/policy1/scaling_governor: Invalid ar=
gument
# governor.sh: line 45: [: =3D=3D: unary operator expected
# cat: /sys/devices/system/cpu/cpufreq/policy2/scaling_governor: Invalid ar=
gument
# governor.sh: line 45: [: =3D=3D: unary operator expected
# cat: /sys/devices/system/cpu/cpufreq/policy3/scaling_governor: Invalid ar=
gument
# governor.sh: line 45: [: =3D=3D: unary operator expected
# cat: /sys/devices/system/cpu/cpufreq/policy4/scaling_governor: Invalid ar=
gument
# governor.sh: line 45: [: =3D=3D: unary operator expected
# cat: /sys/devices/system/cpu/cpufreq/policy5/scaling_governor: Invalid ar=
gument
# governor.sh: line 45: [: =3D=3D: unary operator expected
# cat: /sys/devices/system/cpu/cpufreq/policy6/scaling_governor: Invalid ar=
gument
# governor.sh: line 45: [: =3D=3D: unary operator expected
# cat: /sys/devices/system/cpu/cpufreq/policy7/scaling_governor: Invalid ar=
gument
# governor.sh: line 45: [: =3D=3D: unary operator expected
# cat: /sys/devices/system/cpu/cpufreq/policy0/scaling_governor: Invalid ar=
gument
# governor.sh: line 45: [: =3D=3D: unary operator expected
# governor.sh: line 72: echo: write error: Invalid argument
# governor.sh: line 60: [: =3D=3D: unary operator expected
# cat: /sys/devices/system/cpu/cpufreq/policy1/scaling_governor: Invalid ar=
gument
# governor.sh: line 45: [: =3D=3D: unary operator expected
# governor.sh: line 72: echo: write error: Invalid argument
# governor.sh: line 60: [: =3D=3D: unary operator expected
# cat: /sys/devices/system/cpu/cpufreq/policy2/scaling_governor: Invalid ar=
gument
# governor.sh: line 45: [: =3D=3D: unary operator expected
# governor.sh: line 72: echo: write error: Invalid argument
# governor.sh: line 60: [: =3D=3D: unary operator expected
# cat: /sys/devices/system/cpu/cpufreq/policy3/scaling_governor: Invalid ar=
gument
# governor.sh: line 45: [: =3D=3D: unary operator expected
# governor.sh: line 72: echo: write error: Invalid argument
# governor.sh: line 60: [: =3D=3D: unary operator expected
# cat: /sys/devices/system/cpu/cpufreq/policy4/scaling_governor: Invalid ar=
gument
# governor.sh: line 45: [: =3D=3D: unary operator expected
# governor.sh: line 72: echo: write error: Invalid argument
# governor.sh: line 60: [: =3D=3D: unary operator expected
# cat: /sys/devices/system/cpu/cpufreq/policy5/scaling_governor: Invalid ar=
gument
# governor.sh: line 45: [: =3D=3D: unary operator expected
# governor.sh: line 72: echo: write error: Invalid argument
# governor.sh: line 60: [: =3D=3D: unary operator expected
# cat: /sys/devices/system/cpu/cpufreq/policy6/scaling_governor: Invalid ar=
gument
# governor.sh: line 45: [: =3D=3D: unary operator expected
# governor.sh: line 72: echo: write error: Invalid argument
# governor.sh: line 60: [: =3D=3D: unary operator expected
# cat: /sys/devices/system/cpu/cpufreq/policy7/scaling_governor: Invalid ar=
gument
# governor.sh: line 45: [: =3D=3D: unary operator expected
# governor.sh: line 72: echo: write error: Invalid argument
# governor.sh: line 60: [: =3D=3D: unary operator expected
ok 1 selftests: cpufreq: main.sh
make: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf6=
8e19bf7d303022d873141b5e1f7219/tools/testing/selftests/cpufreq'
dmabuf-heaps test: not in Makefile
2020-04-09 08:13:17 make TARGETS=3Ddmabuf-heaps
make --no-builtin-rules ARCH=3Dx86 -C ../../.. headers_install
make[1]: Entering directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464=
ccf68e19bf7d303022d873141b5e1f7219'
  HOSTCC  scripts/basic/fixdep
  HOSTCC  scripts/unifdef
  WRAP    arch/x86/include/generated/uapi/asm/bpf_perf_event.h
  WRAP    arch/x86/include/generated/uapi/asm/errno.h
  WRAP    arch/x86/include/generated/uapi/asm/fcntl.h
  WRAP    arch/x86/include/generated/uapi/asm/ioctl.h
  WRAP    arch/x86/include/generated/uapi/asm/ioctls.h
  WRAP    arch/x86/include/generated/uapi/asm/ipcbuf.h
  WRAP    arch/x86/include/generated/uapi/asm/param.h
  WRAP    arch/x86/include/generated/uapi/asm/poll.h
  WRAP    arch/x86/include/generated/uapi/asm/resource.h
  WRAP    arch/x86/include/generated/uapi/asm/socket.h
  WRAP    arch/x86/include/generated/uapi/asm/sockios.h
  WRAP    arch/x86/include/generated/uapi/asm/termbits.h
  WRAP    arch/x86/include/generated/uapi/asm/termios.h
  WRAP    arch/x86/include/generated/uapi/asm/types.h
  SYSTBL  arch/x86/include/generated/asm/syscalls_32.h
  SYSHDR  arch/x86/include/generated/uapi/asm/unistd_32.h
  SYSHDR  arch/x86/include/generated/uapi/asm/unistd_64.h
  SYSHDR  arch/x86/include/generated/uapi/asm/unistd_x32.h
  HOSTCC  arch/x86/tools/relocs_32.o
  HOSTCC  arch/x86/tools/relocs_64.o
  HOSTCC  arch/x86/tools/relocs_common.o
  HOSTLD  arch/x86/tools/relocs
  UPD     include/generated/uapi/linux/version.h
  HDRINST usr/include/video/edid.h
  HDRINST usr/include/video/sisfb.h
  HDRINST usr/include/video/uvesafb.h
  HDRINST usr/include/drm/drm_sarea.h
  HDRINST usr/include/drm/etnaviv_drm.h
  HDRINST usr/include/drm/radeon_drm.h
  HDRINST usr/include/drm/msm_drm.h
  HDRINST usr/include/drm/nouveau_drm.h
  HDRINST usr/include/drm/tegra_drm.h
  HDRINST usr/include/drm/i810_drm.h
  HDRINST usr/include/drm/drm_mode.h
  HDRINST usr/include/drm/mga_drm.h
  HDRINST usr/include/drm/i915_drm.h
  HDRINST usr/include/drm/amdgpu_drm.h
  HDRINST usr/include/drm/exynos_drm.h
  HDRINST usr/include/drm/panfrost_drm.h
  HDRINST usr/include/drm/vmwgfx_drm.h
  HDRINST usr/include/drm/v3d_drm.h
  HDRINST usr/include/drm/virtgpu_drm.h
  HDRINST usr/include/drm/r128_drm.h
  HDRINST usr/include/drm/armada_drm.h
  HDRINST usr/include/drm/savage_drm.h
  HDRINST usr/include/drm/via_drm.h
  HDRINST usr/include/drm/omap_drm.h
  HDRINST usr/include/drm/qxl_drm.h
  HDRINST usr/include/drm/vc4_drm.h
  HDRINST usr/include/drm/lima_drm.h
  HDRINST usr/include/drm/drm_fourcc.h
  HDRINST usr/include/drm/vgem_drm.h
  HDRINST usr/include/drm/sis_drm.h
  HDRINST usr/include/drm/drm.h
  HDRINST usr/include/mtd/ubi-user.h
  HDRINST usr/include/mtd/nftl-user.h
  HDRINST usr/include/mtd/mtd-user.h
  HDRINST usr/include/mtd/inftl-user.h
  HDRINST usr/include/mtd/mtd-abi.h
  HDRINST usr/include/xen/gntdev.h
  HDRINST usr/include/xen/evtchn.h
  HDRINST usr/include/xen/gntalloc.h
  HDRINST usr/include/xen/privcmd.h
  HDRINST usr/include/asm-generic/ioctl.h
  HDRINST usr/include/asm-generic/posix_types.h
  HDRINST usr/include/asm-generic/types.h
  HDRINST usr/include/asm-generic/sockios.h
  HDRINST usr/include/asm-generic/swab.h
  HDRINST usr/include/asm-generic/auxvec.h
  HDRINST usr/include/asm-generic/termios.h
  HDRINST usr/include/asm-generic/bpf_perf_event.h
  HDRINST usr/include/asm-generic/signal.h
  HDRINST usr/include/asm-generic/errno.h
  HDRINST usr/include/asm-generic/stat.h
  HDRINST usr/include/asm-generic/ucontext.h
  HDRINST usr/include/asm-generic/mman-common.h
  HDRINST usr/include/asm-generic/statfs.h
  HDRINST usr/include/asm-generic/unistd.h
  HDRINST usr/include/asm-generic/resource.h
  HDRINST usr/include/asm-generic/signal-defs.h
  HDRINST usr/include/asm-generic/bitsperlong.h
  HDRINST usr/include/asm-generic/termbits.h
  HDRINST usr/include/asm-generic/sembuf.h
  HDRINST usr/include/asm-generic/socket.h
  HDRINST usr/include/asm-generic/hugetlb_encode.h
  HDRINST usr/include/asm-generic/ioctls.h
  HDRINST usr/include/asm-generic/setup.h
  HDRINST usr/include/asm-generic/kvm_para.h
  HDRINST usr/include/asm-generic/param.h
  HDRINST usr/include/asm-generic/shmbuf.h
  HDRINST usr/include/asm-generic/mman.h
  HDRINST usr/include/asm-generic/msgbuf.h
  HDRINST usr/include/asm-generic/errno-base.h
  HDRINST usr/include/asm-generic/int-ll64.h
  HDRINST usr/include/asm-generic/poll.h
  HDRINST usr/include/asm-generic/int-l64.h
  HDRINST usr/include/asm-generic/ipcbuf.h
  HDRINST usr/include/asm-generic/fcntl.h
  HDRINST usr/include/asm-generic/siginfo.h
  HDRINST usr/include/rdma/bnxt_re-abi.h
  HDRINST usr/include/rdma/ib_user_verbs.h
  HDRINST usr/include/rdma/rdma_user_ioctl_cmds.h
  HDRINST usr/include/rdma/siw-abi.h
  HDRINST usr/include/rdma/ib_user_mad.h
  HDRINST usr/include/rdma/rdma_netlink.h
  HDRINST usr/include/rdma/rdma_user_rxe.h
  HDRINST usr/include/rdma/vmw_pvrdma-abi.h
  HDRINST usr/include/rdma/ib_user_sa.h
  HDRINST usr/include/rdma/rvt-abi.h
  HDRINST usr/include/rdma/ib_user_ioctl_verbs.h
  HDRINST usr/include/rdma/cxgb4-abi.h
  HDRINST usr/include/rdma/efa-abi.h
  HDRINST usr/include/rdma/mthca-abi.h
  HDRINST usr/include/rdma/mlx5-abi.h
  HDRINST usr/include/rdma/rdma_user_cm.h
  HDRINST usr/include/rdma/rdma_user_ioctl.h
  HDRINST usr/include/rdma/mlx4-abi.h
  HDRINST usr/include/rdma/mlx5_user_ioctl_verbs.h
  HDRINST usr/include/rdma/ocrdma-abi.h
  HDRINST usr/include/rdma/ib_user_ioctl_cmds.h
  HDRINST usr/include/rdma/mlx5_user_ioctl_cmds.h
  HDRINST usr/include/rdma/hfi/hfi1_ioctl.h
  HDRINST usr/include/rdma/hfi/hfi1_user.h
  HDRINST usr/include/rdma/i40iw-abi.h
  HDRINST usr/include/rdma/qedr-abi.h
  HDRINST usr/include/rdma/hns-abi.h
  HDRINST usr/include/misc/cxl.h
  HDRINST usr/include/misc/habanalabs.h
  HDRINST usr/include/misc/fastrpc.h
  HDRINST usr/include/misc/pvpanic.h
  HDRINST usr/include/misc/xilinx_sdfec.h
  HDRINST usr/include/misc/ocxl.h
  HDRINST usr/include/linux/fsi.h
  HDRINST usr/include/linux/dma-heap.h
  HDRINST usr/include/linux/zorro_ids.h
  HDRINST usr/include/linux/nubus.h
  HDRINST usr/include/linux/errqueue.h
  HDRINST usr/include/linux/utime.h
  HDRINST usr/include/linux/if_link.h
  HDRINST usr/include/linux/sysctl.h
  HDRINST usr/include/linux/atalk.h
  HDRINST usr/include/linux/xfrm.h
  HDRINST usr/include/linux/igmp.h
  HDRINST usr/include/linux/ioctl.h
  HDRINST usr/include/linux/virtio_gpu.h
  HDRINST usr/include/linux/nfs.h
  HDRINST usr/include/linux/posix_types.h
  HDRINST usr/include/linux/vboxguest.h
  HDRINST usr/include/linux/spi/spidev.h
  HDRINST usr/include/linux/const.h
  HDRINST usr/include/linux/hidraw.h
  HDRINST usr/include/linux/sctp.h
  HDRINST usr/include/linux/media-bus-format.h
  HDRINST usr/include/linux/in_route.h
  HDRINST usr/include/linux/firewire-constants.h
  HDRINST usr/include/linux/btrfs.h
  HDRINST usr/include/linux/cec-funcs.h
  HDRINST usr/include/linux/ip.h
  HDRINST usr/include/linux/tc_act/tc_ct.h
  HDRINST usr/include/linux/tc_act/tc_csum.h
  HDRINST usr/include/linux/tc_act/tc_bpf.h
  HDRINST usr/include/linux/tc_act/tc_pedit.h
  HDRINST usr/include/linux/tc_act/tc_connmark.h
  HDRINST usr/include/linux/tc_act/tc_ipt.h
  HDRINST usr/include/linux/tc_act/tc_nat.h
  HDRINST usr/include/linux/tc_act/tc_defact.h
  HDRINST usr/include/linux/tc_act/tc_vlan.h
  HDRINST usr/include/linux/tc_act/tc_sample.h
  HDRINST usr/include/linux/tc_act/tc_skbedit.h
  HDRINST usr/include/linux/tc_act/tc_tunnel_key.h
  HDRINST usr/include/linux/tc_act/tc_gact.h
  HDRINST usr/include/linux/tc_act/tc_ife.h
  HDRINST usr/include/linux/tc_act/tc_mpls.h
  HDRINST usr/include/linux/tc_act/tc_skbmod.h
  HDRINST usr/include/linux/tc_act/tc_mirred.h
  HDRINST usr/include/linux/tc_act/tc_ctinfo.h
  HDRINST usr/include/linux/types.h
  HDRINST usr/include/linux/tipc.h
  HDRINST usr/include/linux/sockios.h
  HDRINST usr/include/linux/virtio_pmem.h
  HDRINST usr/include/linux/auto_dev-ioctl.h
  HDRINST usr/include/linux/dvb/osd.h
  HDRINST usr/include/linux/dvb/version.h
  HDRINST usr/include/linux/dvb/video.h
  HDRINST usr/include/linux/dvb/ca.h
  HDRINST usr/include/linux/dvb/frontend.h
  HDRINST usr/include/linux/dvb/audio.h
  HDRINST usr/include/linux/dvb/dmx.h
  HDRINST usr/include/linux/dvb/net.h
  HDRINST usr/include/linux/kvm.h
  HDRINST usr/include/linux/cuda.h
  HDRINST usr/include/linux/virtio_scsi.h
  HDRINST usr/include/linux/firewire-cdev.h
  HDRINST usr/include/linux/tty.h
  HDRINST usr/include/linux/android/binder.h
  HDRINST usr/include/linux/android/binderfs.h
  HDRINST usr/include/linux/soundcard.h
  HDRINST usr/include/linux/isdn/capicmd.h
  HDRINST usr/include/linux/dma-buf.h
  HDRINST usr/include/linux/memfd.h
  HDRINST usr/include/linux/dlm_netlink.h
  HDRINST usr/include/linux/pkt_cls.h
  HDRINST usr/include/linux/pmu.h
  HDRINST usr/include/linux/uinput.h
  HDRINST usr/include/linux/ncsi.h
  HDRINST usr/include/linux/swab.h
  HDRINST usr/include/linux/hpet.h
  HDRINST usr/include/linux/shm.h
  HDRINST usr/include/linux/synclink.h
  HDRINST usr/include/linux/mroute6.h
  HDRINST usr/include/linux/mic_ioctl.h
  HDRINST usr/include/linux/isst_if.h
  HDRINST usr/include/linux/libc-compat.h
  HDRINST usr/include/linux/ila.h
  HDRINST usr/include/linux/elf-fdpic.h
  HDRINST usr/include/linux/wimax/i2400m.h
  HDRINST usr/include/linux/if_eql.h
  HDRINST usr/include/linux/if_slip.h
  HDRINST usr/include/linux/tcp.h
  HDRINST usr/include/linux/netdevice.h
  HDRINST usr/include/linux/rxrpc.h
  HDRINST usr/include/linux/nfsacl.h
  HDRINST usr/include/linux/nvme_ioctl.h
  HDRINST usr/include/linux/qemu_fw_cfg.h
  HDRINST usr/include/linux/openvswitch.h
  HDRINST usr/include/linux/landlock.h
  HDRINST usr/include/linux/tcp_metrics.h
  HDRINST usr/include/linux/cramfs_fs.h
  HDRINST usr/include/linux/psample.h
  HDRINST usr/include/linux/tiocl.h
  HDRINST usr/include/linux/dns_resolver.h
  HDRINST usr/include/linux/cm4000_cs.h
  HDRINST usr/include/linux/random.h
  HDRINST usr/include/linux/nl80211.h
  HDRINST usr/include/linux/cryptouser.h
  HDRINST usr/include/linux/if_phonet.h
  HDRINST usr/include/linux/nfs2.h
  HDRINST usr/include/linux/neighbour.h
  HDRINST usr/include/linux/arm_sdei.h
  HDRINST usr/include/linux/mtio.h
  HDRINST usr/include/linux/coff.h
  HDRINST usr/include/linux/lp.h
  HDRINST usr/include/linux/rseq.h
  HDRINST usr/include/linux/apm_bios.h
  HDRINST usr/include/linux/ndctl.h
  HDRINST usr/include/linux/nvram.h
  HDRINST usr/include/linux/fdreg.h
  HDRINST usr/include/linux/blktrace_api.h
  HDRINST usr/include/linux/seg6_genl.h
  HDRINST usr/include/linux/qrtr.h
  HDRINST usr/include/linux/btrfs_tree.h
  HDRINST usr/include/linux/kd.h
  HDRINST usr/include/linux/quota.h
  HDRINST usr/include/linux/hdlc/ioctl.h
  HDRINST usr/include/linux/bcm933xx_hcs.h
  HDRINST usr/include/linux/timerfd.h
  HDRINST usr/include/linux/ipmi_msgdefs.h
  HDRINST usr/include/linux/max2175.h
  HDRINST usr/include/linux/tipc_netlink.h
  HDRINST usr/include/linux/ethtool_netlink.h
  HDRINST usr/include/linux/aspeed-p2a-ctrl.h
  HDRINST usr/include/linux/if_plip.h
  HDRINST usr/include/linux/mempolicy.h
  HDRINST usr/include/linux/atmsap.h
  HDRINST usr/include/linux/sched.h
  HDRINST usr/include/linux/atmmpc.h
  HDRINST usr/include/linux/tty_flags.h
  HDRINST usr/include/linux/msg.h
  HDRINST usr/include/linux/l2tp.h
  HDRINST usr/include/linux/netrom.h
  HDRINST usr/include/linux/smc.h
  HDRINST usr/include/linux/ipx.h
  HDRINST usr/include/linux/auxvec.h
  HDRINST usr/include/linux/netfilter.h
  HDRINST usr/include/linux/tee.h
  HDRINST usr/include/linux/udp.h
  HDRINST usr/include/linux/fou.h
  HDRINST usr/include/linux/ivtvfb.h
  HDRINST usr/include/linux/raw.h
  HDRINST usr/include/linux/tipc_sockets_diag.h
  HDRINST usr/include/linux/io_uring.h
  HDRINST usr/include/linux/rds.h
  HDRINST usr/include/linux/virtio_console.h
  HDRINST usr/include/linux/can/j1939.h
  HDRINST usr/include/linux/can/vxcan.h
  HDRINST usr/include/linux/can/raw.h
  HDRINST usr/include/linux/can/gw.h
  HDRINST usr/include/linux/can/error.h
  HDRINST usr/include/linux/can/netlink.h
  HDRINST usr/include/linux/can/bcm.h
  HDRINST usr/include/linux/vbox_err.h
  HDRINST usr/include/linux/byteorder/little_endian.h
  HDRINST usr/include/linux/byteorder/big_endian.h
  HDRINST usr/include/linux/if_ppp.h
  HDRINST usr/include/linux/kdev_t.h
  HDRINST usr/include/linux/sock_diag.h
  HDRINST usr/include/linux/coresight-stm.h
  HDRINST usr/include/linux/hdlcdrv.h
  HDRINST usr/include/linux/netfilter_ipv4/ip_tables.h
  HDRINST usr/include/linux/netfilter_ipv4/ipt_ECN.h
  HDRINST usr/include/linux/netfilter_ipv4/ipt_CLUSTERIP.h
  HDRINST usr/include/linux/netfilter_ipv4/ipt_LOG.h
  HDRINST usr/include/linux/netfilter_ipv4/ipt_ecn.h
  HDRINST usr/include/linux/netfilter_ipv4/ipt_ah.h
  HDRINST usr/include/linux/netfilter_ipv4/ipt_TTL.h
  HDRINST usr/include/linux/netfilter_ipv4/ipt_REJECT.h
  HDRINST usr/include/linux/netfilter_ipv4/ipt_ttl.h
  HDRINST usr/include/linux/fs.h
  HDRINST usr/include/linux/btf.h
  HDRINST usr/include/linux/caif/caif_socket.h
  HDRINST usr/include/linux/caif/if_caif.h
  HDRINST usr/include/linux/bfs_fs.h
  HDRINST usr/include/linux/ppp-comp.h
  HDRINST usr/include/linux/in6.h
  HDRINST usr/include/linux/cec.h
  HDRINST usr/include/linux/xdp_diag.h
  HDRINST usr/include/linux/termios.h
  HDRINST usr/include/linux/hid.h
  HDRINST usr/include/linux/nfs_mount.h
  HDRINST usr/include/linux/vtpm_proxy.h
  HDRINST usr/include/linux/taskstats.h
  HDRINST usr/include/linux/vfio.h
  HDRINST usr/include/linux/auto_fs4.h
  HDRINST usr/include/linux/pg.h
  HDRINST usr/include/linux/bpf_perf_event.h
  HDRINST usr/include/linux/packet_diag.h
  HDRINST usr/include/linux/vt.h
  HDRINST usr/include/linux/ip_vs.h
  HDRINST usr/include/linux/pktcdvd.h
  HDRINST usr/include/linux/mdio.h
  HDRINST usr/include/linux/virtio_ring.h
  HDRINST usr/include/linux/gameport.h
  HDRINST usr/include/linux/time.h
  HDRINST usr/include/linux/prctl.h
  HDRINST usr/include/linux/patchkey.h
  HDRINST usr/include/linux/lightnvm.h
  HDRINST usr/include/linux/ethtool.h
  HDRINST usr/include/linux/target_core_user.h
  HDRINST usr/include/linux/timex.h
  HDRINST usr/include/linux/seccomp.h
  HDRINST usr/include/linux/signal.h
  HDRINST usr/include/linux/if_hippi.h
  HDRINST usr/include/linux/if_alg.h
  HDRINST usr/include/linux/dccp.h
  HDRINST usr/include/linux/virtio_types.h
  HDRINST usr/include/linux/seg6_hmac.h
  HDRINST usr/include/linux/vm_sockets_diag.h
  HDRINST usr/include/linux/virtio_config.h
  HDRINST usr/include/linux/fadvise.h
  HDRINST usr/include/linux/capability.h
  HDRINST usr/include/linux/hdreg.h
  HDRINST usr/include/linux/virtio_iommu.h
  HDRINST usr/include/linux/if_addrlabel.h
  HDRINST usr/include/linux/if_fc.h
  HDRINST usr/include/linux/scif_ioctl.h
  HDRINST usr/include/linux/input.h
  HDRINST usr/include/linux/wireless.h
  HDRINST usr/include/linux/unix_diag.h
  HDRINST usr/include/linux/joystick.h
  HDRINST usr/include/linux/netfilter_arp.h
  HDRINST usr/include/linux/uio.h
  HDRINST usr/include/linux/nbd-netlink.h
  HDRINST usr/include/linux/vhost.h
  HDRINST usr/include/linux/input-event-codes.h
  HDRINST usr/include/linux/cgroupstats.h
  HDRINST usr/include/linux/pci.h
  HDRINST usr/include/linux/screen_info.h
  HDRINST usr/include/linux/reboot.h
  HDRINST usr/include/linux/bpf_common.h
  HDRINST usr/include/linux/limits.h
  HDRINST usr/include/linux/iso_fs.h
  HDRINST usr/include/linux/errno.h
  HDRINST usr/include/linux/reiserfs_fs.h
  HDRINST usr/include/linux/v4l2-subdev.h
  HDRINST usr/include/linux/if_tun.h
  HDRINST usr/include/linux/dcbnl.h
  HDRINST usr/include/linux/atm_idt77105.h
  HDRINST usr/include/linux/ipmi.h
  HDRINST usr/include/linux/mroute.h
  HDRINST usr/include/linux/stat.h
  HDRINST usr/include/linux/un.h
  HDRINST usr/include/linux/agpgart.h
  HDRINST usr/include/linux/icmpv6.h
  HDRINST usr/include/linux/batadv_packet.h
  HDRINST usr/include/linux/if_arcnet.h
  HDRINST usr/include/linux/uleds.h
  HDRINST usr/include/linux/cciss_ioctl.h
  HDRINST usr/include/linux/adfs_fs.h
  HDRINST usr/include/linux/vhost_types.h
  HDRINST usr/include/linux/elf.h
  HDRINST usr/include/linux/rtc.h
  HDRINST usr/include/linux/ppp_defs.h
  HDRINST usr/include/linux/stm.h
  HDRINST usr/include/linux/hyperv.h
  HDRINST usr/include/linux/cdrom.h
  HDRINST usr/include/linux/nfs_idmap.h
  HDRINST usr/include/linux/hdlc.h
  HDRINST usr/include/linux/kernel.h
  HDRINST usr/include/linux/time_types.h
  HDRINST usr/include/linux/mmtimer.h
  HDRINST usr/include/linux/virtio_ids.h
  HDRINST usr/include/linux/nsfs.h
  HDRINST usr/include/linux/ptp_clock.h
  HDRINST usr/include/linux/if_cablemodem.h
  HDRINST usr/include/linux/meye.h
  HDRINST usr/include/linux/net_namespace.h
  HDRINST usr/include/linux/a.out.h
  HDRINST usr/include/linux/fpga-dfl.h
  HDRINST usr/include/linux/if_frad.h
  HDRINST usr/include/linux/zorro.h
  HDRINST usr/include/linux/dlm_plock.h
  HDRINST usr/include/linux/usbip.h
  HDRINST usr/include/linux/bt-bmc.h
  HDRINST usr/include/linux/sonypi.h
  HDRINST usr/include/linux/lirc.h
  HDRINST usr/include/linux/tls.h
  HDRINST usr/include/linux/virtio_blk.h
  HDRINST usr/include/linux/ultrasound.h
  HDRINST usr/include/linux/switchtec_ioctl.h
  HDRINST usr/include/linux/unistd.h
  HDRINST usr/include/linux/stddef.h
  HDRINST usr/include/linux/eventpoll.h
  HDRINST usr/include/linux/fscrypt.h
  HDRINST usr/include/linux/resource.h
  HDRINST usr/include/linux/serial_core.h
  HDRINST usr/include/linux/i2c-dev.h
  HDRINST usr/include/linux/vmcore.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_mark_m.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_nat.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_mark_t.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_log.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_arp.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_ip.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_stp.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_among.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_ip6.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_redirect.h
  HDRINST usr/include/linux/netfilter_bridge/ebtables.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_nflog.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_arpreply.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_802_3.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_vlan.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_pkttype.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_limit.h
  HDRINST usr/include/linux/securebits.h
  HDRINST usr/include/linux/fsmap.h
  HDRINST usr/include/linux/lwtunnel.h
  HDRINST usr/include/linux/genwqe/genwqe_card.h
  HDRINST usr/include/linux/sem.h
  HDRINST usr/include/linux/sonet.h
  HDRINST usr/include/linux/atm_tcp.h
  HDRINST usr/include/linux/i2o-dev.h
  HDRINST usr/include/linux/pkt_sched.h
  HDRINST usr/include/linux/omap3isp.h
  HDRINST usr/include/linux/if_packet.h
  HDRINST usr/include/linux/cifs/cifs_mount.h
  HDRINST usr/include/linux/hiddev.h
  HDRINST usr/include/linux/elf-em.h
  HDRINST usr/include/linux/seg6.h
  HDRINST usr/include/linux/in.h
  HDRINST usr/include/linux/uuid.h
  HDRINST usr/include/linux/perf_event.h
  HDRINST usr/include/linux/pfkeyv2.h
  HDRINST usr/include/linux/pr.h
  HDRINST usr/include/linux/wireguard.h
  HDRINST usr/include/linux/major.h
  HDRINST usr/include/linux/dlmconstants.h
  HDRINST usr/include/linux/atm_he.h
  HDRINST usr/include/linux/atmppp.h
  HDRINST usr/include/linux/signalfd.h
  HDRINST usr/include/linux/openat2.h
  HDRINST usr/include/linux/smiapp.h
  HDRINST usr/include/linux/usbdevice_fs.h
  HDRINST usr/include/linux/mmc/ioctl.h
  HDRINST usr/include/linux/netfilter_arp/arp_tables.h
  HDRINST usr/include/linux/netfilter_arp/arpt_mangle.h
  HDRINST usr/include/linux/audit.h
  HDRINST usr/include/linux/bpfilter.h
  HDRINST usr/include/linux/inet_diag.h
  HDRINST usr/include/linux/msdos_fs.h
  HDRINST usr/include/linux/watchdog.h
  HDRINST usr/include/linux/xattr.h
  HDRINST usr/include/linux/bpf.h
  HDRINST usr/include/linux/pps.h
  HDRINST usr/include/linux/atm_nicstar.h
  HDRINST usr/include/linux/if_infiniband.h
  HDRINST usr/include/linux/rpmsg.h
  HDRINST usr/include/linux/loop.h
  HDRINST usr/include/linux/dqblk_xfs.h
  HDRINST usr/include/linux/selinux_netlink.h
  HDRINST usr/include/linux/mpls_iptunnel.h
  HDRINST usr/include/linux/psci.h
  HDRINST usr/include/linux/v4l2-common.h
  HDRINST usr/include/linux/mic_common.h
  HDRINST usr/include/linux/virtio_rng.h
  HDRINST usr/include/linux/netfilter_ipv6.h
  HDRINST usr/include/linux/x25.h
  HDRINST usr/include/linux/userfaultfd.h
  HDRINST usr/include/linux/fb.h
  HDRINST usr/include/linux/rio_cm_cdev.h
  HDRINST usr/include/linux/ife.h
  HDRINST usr/include/linux/dlm_device.h
  HDRINST usr/include/linux/llc.h
  HDRINST usr/include/linux/vfio_ccw.h
  HDRINST usr/include/linux/ipv6.h
  HDRINST usr/include/linux/adb.h
  HDRINST usr/include/linux/seg6_local.h
  HDRINST usr/include/linux/arcfb.h
  HDRINST usr/include/linux/socket.h
  HDRINST usr/include/linux/jffs2.h
  HDRINST usr/include/linux/filter.h
  HDRINST usr/include/linux/ip6_tunnel.h
  HDRINST usr/include/linux/rtnetlink.h
  HDRINST usr/include/linux/veth.h
  HDRINST usr/include/linux/atmclip.h
  HDRINST usr/include/linux/if_bonding.h
  HDRINST usr/include/linux/ax25.h
  HDRINST usr/include/linux/utsname.h
  HDRINST usr/include/linux/if_ltalk.h
  HDRINST usr/include/linux/sunrpc/debug.h
  HDRINST usr/include/linux/keyctl.h
  HDRINST usr/include/linux/bcache.h
  HDRINST usr/include/linux/raid/md_u.h
  HDRINST usr/include/linux/raid/md_p.h
  HDRINST usr/include/linux/acct.h
  HDRINST usr/include/linux/irqnr.h
  HDRINST usr/include/linux/hw_breakpoint.h
  HDRINST usr/include/linux/baycom.h
  HDRINST usr/include/linux/ptrace.h
  HDRINST usr/include/linux/if_pppol2tp.h
  HDRINST usr/include/linux/nilfs2_ondisk.h
  HDRINST usr/include/linux/connector.h
  HDRINST usr/include/linux/if_bridge.h
  HDRINST usr/include/linux/gpio.h
  HDRINST usr/include/linux/udmabuf.h
  HDRINST usr/include/linux/virtio_mmio.h
  HDRINST usr/include/linux/nfs_fs.h
  HDRINST usr/include/linux/netfilter/xt_set.h
  HDRINST usr/include/linux/netfilter/xt_IDLETIMER.h
  HDRINST usr/include/linux/netfilter/nfnetlink_conntrack.h
  HDRINST usr/include/linux/netfilter/xt_policy.h
  HDRINST usr/include/linux/netfilter/nfnetlink.h
  HDRINST usr/include/linux/netfilter/xt_sctp.h
  HDRINST usr/include/linux/netfilter/xt_MARK.h
  HDRINST usr/include/linux/netfilter/xt_CONNMARK.h
  HDRINST usr/include/linux/netfilter/xt_cgroup.h
  HDRINST usr/include/linux/netfilter/nf_conntrack_sctp.h
  HDRINST usr/include/linux/netfilter/nfnetlink_cttimeout.h
  HDRINST usr/include/linux/netfilter/xt_string.h
  HDRINST usr/include/linux/netfilter/xt_connlimit.h
  HDRINST usr/include/linux/netfilter/xt_statistic.h
  HDRINST usr/include/linux/netfilter/xt_nfacct.h
  HDRINST usr/include/linux/netfilter/xt_helper.h
  HDRINST usr/include/linux/netfilter/nf_conntrack_tuple_common.h
  HDRINST usr/include/linux/netfilter/xt_u32.h
  HDRINST usr/include/linux/netfilter/xt_cluster.h
  HDRINST usr/include/linux/netfilter/xt_RATEEST.h
  HDRINST usr/include/linux/netfilter/xt_recent.h
  HDRINST usr/include/linux/netfilter/x_tables.h
  HDRINST usr/include/linux/netfilter/xt_hashlimit.h
  HDRINST usr/include/linux/netfilter/xt_connmark.h
  HDRINST usr/include/linux/netfilter/nfnetlink_compat.h
  HDRINST usr/include/linux/netfilter/xt_devgroup.h
  HDRINST usr/include/linux/netfilter/xt_TPROXY.h
  HDRINST usr/include/linux/netfilter/xt_realm.h
  HDRINST usr/include/linux/netfilter/xt_LOG.h
  HDRINST usr/include/linux/netfilter/xt_tcpmss.h
  HDRINST usr/include/linux/netfilter/xt_SYNPROXY.h
  HDRINST usr/include/linux/netfilter/xt_conntrack.h
  HDRINST usr/include/linux/netfilter/xt_rpfilter.h
  HDRINST usr/include/linux/netfilter/ipset/ip_set_bitmap.h
  HDRINST usr/include/linux/netfilter/ipset/ip_set_hash.h
  HDRINST usr/include/linux/netfilter/ipset/ip_set.h
  HDRINST usr/include/linux/netfilter/ipset/ip_set_list.h
  HDRINST usr/include/linux/netfilter/xt_SECMARK.h
  HDRINST usr/include/linux/netfilter/xt_dscp.h
  HDRINST usr/include/linux/netfilter/xt_CLASSIFY.h
  HDRINST usr/include/linux/netfilter/xt_CONNSECMARK.h
  HDRINST usr/include/linux/netfilter/xt_bpf.h
  HDRINST usr/include/linux/netfilter/xt_socket.h
  HDRINST usr/include/linux/netfilter/nf_conntrack_ftp.h
  HDRINST usr/include/linux/netfilter/xt_comment.h
  HDRINST usr/include/linux/netfilter/nf_nat.h
  HDRINST usr/include/linux/netfilter/xt_CT.h
  HDRINST usr/include/linux/netfilter/xt_dccp.h
  HDRINST usr/include/linux/netfilter/xt_mark.h
  HDRINST usr/include/linux/netfilter/nf_conntrack_common.h
  HDRINST usr/include/linux/netfilter/xt_mac.h
  HDRINST usr/include/linux/netfilter/xt_cpu.h
  HDRINST usr/include/linux/netfilter/nf_synproxy.h
  HDRINST usr/include/linux/netfilter/xt_limit.h
  HDRINST usr/include/linux/netfilter/xt_connbytes.h
  HDRINST usr/include/linux/netfilter/xt_CHECKSUM.h
  HDRINST usr/include/linux/netfilter/xt_iprange.h
  HDRINST usr/include/linux/netfilter/xt_connlabel.h
  HDRINST usr/include/linux/netfilter/xt_time.h
  HDRINST usr/include/linux/netfilter/xt_addrtype.h
  HDRINST usr/include/linux/netfilter/xt_tcpudp.h
  HDRINST usr/include/linux/netfilter/xt_DSCP.h
  HDRINST usr/include/linux/netfilter/xt_state.h
  HDRINST usr/include/linux/netfilter/xt_length.h
  HDRINST usr/include/linux/netfilter/xt_NFQUEUE.h
  HDRINST usr/include/linux/netfilter/xt_physdev.h
  HDRINST usr/include/linux/netfilter/xt_LED.h
  HDRINST usr/include/linux/netfilter/nfnetlink_queue.h
  HDRINST usr/include/linux/netfilter/xt_owner.h
  HDRINST usr/include/linux/netfilter/xt_pkttype.h
  HDRINST usr/include/linux/netfilter/nf_tables_compat.h
  HDRINST usr/include/linux/netfilter/nf_conntrack_tcp.h
  HDRINST usr/include/linux/netfilter/xt_NFLOG.h
  HDRINST usr/include/linux/netfilter/xt_ipcomp.h
  HDRINST usr/include/linux/netfilter/nfnetlink_log.h
  HDRINST usr/include/linux/netfilter/xt_multiport.h
  HDRINST usr/include/linux/netfilter/nfnetlink_osf.h
  HDRINST usr/include/linux/netfilter/xt_TCPMSS.h
  HDRINST usr/include/linux/netfilter/nf_tables.h
  HDRINST usr/include/linux/netfilter/xt_ecn.h
  HDRINST usr/include/linux/netfilter/xt_HMARK.h
  HDRINST usr/include/linux/netfilter/xt_osf.h
  HDRINST usr/include/linux/netfilter/xt_quota.h
  HDRINST usr/include/linux/netfilter/xt_rateest.h
  HDRINST usr/include/linux/netfilter/xt_esp.h
  HDRINST usr/include/linux/netfilter/nfnetlink_acct.h
  HDRINST usr/include/linux/netfilter/nf_log.h
  HDRINST usr/include/linux/netfilter/xt_AUDIT.h
  HDRINST usr/include/linux/netfilter/xt_TEE.h
  HDRINST usr/include/linux/netfilter/nfnetlink_cthelper.h
  HDRINST usr/include/linux/netfilter/xt_l2tp.h
  HDRINST usr/include/linux/netfilter/xt_ipvs.h
  HDRINST usr/include/linux/netfilter/xt_TCPOPTSTRIP.h
  HDRINST usr/include/linux/nfsd/debug.h
  HDRINST usr/include/linux/nfsd/stats.h
  HDRINST usr/include/linux/nfsd/nfsfh.h
  HDRINST usr/include/linux/nfsd/export.h
  HDRINST usr/include/linux/nfsd/cld.h
  HDRINST usr/include/linux/dlm.h
  HDRINST usr/include/linux/fanotify.h
  HDRINST usr/include/linux/kvm_para.h
  HDRINST usr/include/linux/hsr_netlink.h
  HDRINST usr/include/linux/fsl_hypervisor.h
  HDRINST usr/include/linux/pcitest.h
  HDRINST usr/include/linux/atm.h
  HDRINST usr/include/linux/mqueue.h
  HDRINST usr/include/linux/sed-opal.h
  HDRINST usr/include/linux/videodev2.h
  HDRINST usr/include/linux/tc_ematch/tc_em_cmp.h
  HDRINST usr/include/linux/tc_ematch/tc_em_text.h
  HDRINST usr/include/linux/tc_ematch/tc_em_meta.h
  HDRINST usr/include/linux/tc_ematch/tc_em_nbyte.h
  HDRINST usr/include/linux/tc_ematch/tc_em_ipt.h
  HDRINST usr/include/linux/if_addr.h
  HDRINST usr/include/linux/netfilter_ipv4.h
  HDRINST usr/include/linux/idxd.h
  HDRINST usr/include/linux/affs_hardblocks.h
  HDRINST usr/include/linux/param.h
  HDRINST usr/include/linux/kexec.h
  HDRINST usr/include/linux/dn.h
  HDRINST usr/include/linux/futex.h
  HDRINST usr/include/linux/genetlink.h
  HDRINST usr/include/linux/usb/cdc-wdm.h
  HDRINST usr/include/linux/usb/g_uvc.h
  HDRINST usr/include/linux/usb/video.h
  HDRINST usr/include/linux/usb/charger.h
  HDRINST usr/include/linux/usb/audio.h
  HDRINST usr/include/linux/usb/g_printer.h
  HDRINST usr/include/linux/usb/midi.h
  HDRINST usr/include/linux/usb/tmc.h
  HDRINST usr/include/linux/usb/gadgetfs.h
  HDRINST usr/include/linux/usb/functionfs.h
  HDRINST usr/include/linux/usb/ch11.h
  HDRINST usr/include/linux/usb/ch9.h
  HDRINST usr/include/linux/usb/cdc.h
  HDRINST usr/include/linux/posix_acl.h
  HDRINST usr/include/linux/chio.h
  HDRINST usr/include/linux/fiemap.h
  HDRINST usr/include/linux/atmsvc.h
  HDRINST usr/include/linux/vm_sockets.h
  HDRINST usr/include/linux/vbox_vmmdev_types.h
  HDRINST usr/include/linux/keyboard.h
  HDRINST usr/include/linux/smc_diag.h
  HDRINST usr/include/linux/mpls.h
  HDRINST usr/include/linux/qnx4_fs.h
  HDRINST usr/include/linux/cn_proc.h
  HDRINST usr/include/linux/sdla.h
  HDRINST usr/include/linux/binfmts.h
  HDRINST usr/include/linux/gsmmux.h
  HDRINST usr/include/linux/if_ether.h
  HDRINST usr/include/linux/sync_file.h
  HDRINST usr/include/linux/parport.h
  HDRINST usr/include/linux/virtio_fs.h
  HDRINST usr/include/linux/bsg.h
  HDRINST usr/include/linux/ivtv.h
  HDRINST usr/include/linux/atmioc.h
  HDRINST usr/include/linux/coda.h
  HDRINST usr/include/linux/suspend_ioctls.h
  HDRINST usr/include/linux/cciss_defs.h
  HDRINST usr/include/linux/uvcvideo.h
  HDRINST usr/include/linux/romfs_fs.h
  HDRINST usr/include/linux/ipc.h
  HDRINST usr/include/linux/aspeed-lpc-ctrl.h
  HDRINST usr/include/linux/kcmp.h
  HDRINST usr/include/linux/falloc.h
  HDRINST usr/include/linux/wimax.h
  HDRINST usr/include/linux/sched/types.h
  HDRINST usr/include/linux/membarrier.h
  HDRINST usr/include/linux/uhid.h
  HDRINST usr/include/linux/atmdev.h
  HDRINST usr/include/linux/fsverity.h
  HDRINST usr/include/linux/hsi/hsi_char.h
  HDRINST usr/include/linux/hsi/cs-protocol.h
  HDRINST usr/include/linux/media.h
  HDRINST usr/include/linux/psp-sev.h
  HDRINST usr/include/linux/n_r3964.h
  HDRINST usr/include/linux/icmp.h
  HDRINST usr/include/linux/virtio_input.h
  HDRINST usr/include/linux/am437x-vpfe.h
  HDRINST usr/include/linux/vsockmon.h
  HDRINST usr/include/linux/if.h
  HDRINST usr/include/linux/ipmi_bmc.h
  HDRINST usr/include/linux/cycx_cfm.h
  HDRINST usr/include/linux/mii.h
  HDRINST usr/include/linux/kcm.h
  HDRINST usr/include/linux/omapfb.h
  HDRINST usr/include/linux/dm-ioctl.h
  HDRINST usr/include/linux/nfs3.h
  HDRINST usr/include/linux/netlink.h
  HDRINST usr/include/linux/iommu.h
  HDRINST usr/include/linux/netconf.h
  HDRINST usr/include/linux/gtp.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6t_srh.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6t_rt.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6_tables.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6t_frag.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6t_REJECT.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6t_LOG.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6t_mh.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6t_opts.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6t_ipv6header.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6t_ah.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6t_HL.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6t_NPT.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6t_hl.h
  HDRINST usr/include/linux/nexthop.h
  HDRINST usr/include/linux/batman_adv.h
  HDRINST usr/include/linux/if_arp.h
  HDRINST usr/include/linux/mount.h
  HDRINST usr/include/linux/atmarp.h
  HDRINST usr/include/linux/qnxtypes.h
  HDRINST usr/include/linux/minix_fs.h
  HDRINST usr/include/linux/i2c.h
  HDRINST usr/include/linux/kernelcapi.h
  HDRINST usr/include/linux/route.h
  HDRINST usr/include/linux/devlink.h
  HDRINST usr/include/linux/mei.h
  HDRINST usr/include/linux/if_tunnel.h
  HDRINST usr/include/linux/kfd_ioctl.h
  HDRINST usr/include/linux/v4l2-dv-timings.h
  HDRINST usr/include/linux/i8k.h
  HDRINST usr/include/linux/nfc.h
  HDRINST usr/include/linux/erspan.h
  HDRINST usr/include/linux/if_vlan.h
  HDRINST usr/include/linux/serial_reg.h
  HDRINST usr/include/linux/virtio_net.h
  HDRINST usr/include/linux/udf_fs_i.h
  HDRINST usr/include/linux/v4l2-mediabus.h
  HDRINST usr/include/linux/fib_rules.h
  HDRINST usr/include/linux/nfs4_mount.h
  HDRINST usr/include/linux/can.h
  HDRINST usr/include/linux/kernel-page-flags.h
  HDRINST usr/include/linux/gen_stats.h
  HDRINST usr/include/linux/if_fddi.h
  HDRINST usr/include/linux/reiserfs_xattr.h
  HDRINST usr/include/linux/if_team.h
  HDRINST usr/include/linux/atmapi.h
  HDRINST usr/include/linux/atm_zatm.h
  HDRINST usr/include/linux/personality.h
  HDRINST usr/include/linux/inotify.h
  HDRINST usr/include/linux/atm_eni.h
  HDRINST usr/include/linux/oom.h
  HDRINST usr/include/linux/radeonfb.h
  HDRINST usr/include/linux/posix_acl_xattr.h
  HDRINST usr/include/linux/tipc_config.h
  HDRINST usr/include/linux/rfkill.h
  HDRINST usr/include/linux/mman.h
  HDRINST usr/include/linux/snmp.h
  HDRINST usr/include/linux/iio/types.h
  HDRINST usr/include/linux/iio/events.h
  HDRINST usr/include/linux/seg6_iptunnel.h
  HDRINST usr/include/linux/magic.h
  HDRINST usr/include/linux/thermal.h
  HDRINST usr/include/linux/blkpg.h
  HDRINST usr/include/linux/wait.h
  HDRINST usr/include/linux/string.h
  HDRINST usr/include/linux/nilfs2_api.h
  HDRINST usr/include/linux/netfilter_bridge.h
  HDRINST usr/include/linux/if_xdp.h
  HDRINST usr/include/linux/times.h
  HDRINST usr/include/linux/rose.h
  HDRINST usr/include/linux/rio_mport_cdev.h
  HDRINST usr/include/linux/atmlec.h
  HDRINST usr/include/linux/fuse.h
  HDRINST usr/include/linux/net_tstamp.h
  HDRINST usr/include/linux/edd.h
  HDRINST usr/include/linux/blkzoned.h
  HDRINST usr/include/linux/pci_regs.h
  HDRINST usr/include/linux/matroxfb.h
  HDRINST usr/include/linux/fd.h
  HDRINST usr/include/linux/cyclades.h
  HDRINST usr/include/linux/serial.h
  HDRINST usr/include/linux/ipv6_route.h
  HDRINST usr/include/linux/gfs2_ondisk.h
  HDRINST usr/include/linux/serio.h
  HDRINST usr/include/linux/virtio_pci.h
  HDRINST usr/include/linux/sound.h
  HDRINST usr/include/linux/sysinfo.h
  HDRINST usr/include/linux/nbd.h
  HDRINST usr/include/linux/poll.h
  HDRINST usr/include/linux/phantom.h
  HDRINST usr/include/linux/efs_fs_sb.h
  HDRINST usr/include/linux/virtio_9p.h
  HDRINST usr/include/linux/virtio_vsock.h
  HDRINST usr/include/linux/v4l2-controls.h
  HDRINST usr/include/linux/if_x25.h
  HDRINST usr/include/linux/bpqether.h
  HDRINST usr/include/linux/hash_info.h
  HDRINST usr/include/linux/kcov.h
  HDRINST usr/include/linux/if_pppox.h
  HDRINST usr/include/linux/netfilter_decnet.h
  HDRINST usr/include/linux/phonet.h
  HDRINST usr/include/linux/dm-log-userspace.h
  HDRINST usr/include/linux/scc.h
  HDRINST usr/include/linux/if_macsec.h
  HDRINST usr/include/linux/nfs4.h
  HDRINST usr/include/linux/auto_fs.h
  HDRINST usr/include/linux/ppp-ioctl.h
  HDRINST usr/include/linux/elfcore.h
  HDRINST usr/include/linux/toshiba.h
  HDRINST usr/include/linux/xilinx-v4l2-controls.h
  HDRINST usr/include/linux/fcntl.h
  HDRINST usr/include/linux/userio.h
  HDRINST usr/include/linux/net_dropmon.h
  HDRINST usr/include/linux/ipsec.h
  HDRINST usr/include/linux/ppdev.h
  HDRINST usr/include/linux/virtio_crypto.h
  HDRINST usr/include/linux/wmi.h
  HDRINST usr/include/linux/map_to_7segment.h
  HDRINST usr/include/linux/module.h
  HDRINST usr/include/linux/atmbr2684.h
  HDRINST usr/include/linux/netlink_diag.h
  HDRINST usr/include/linux/virtio_balloon.h
  HDRINST usr/include/linux/net.h
  HDRINST usr/include/linux/aio_abi.h
  HDRINST usr/include/linux/capi.h
  HDRINST usr/include/sound/sfnt_info.h
  HDRINST usr/include/sound/hdspm.h
  HDRINST usr/include/sound/sb16_csp.h
  HDRINST usr/include/sound/compress_offload.h
  HDRINST usr/include/sound/tlv.h
  HDRINST usr/include/sound/skl-tplg-interface.h
  HDRINST usr/include/sound/emu10k1.h
  HDRINST usr/include/sound/asound_fm.h
  HDRINST usr/include/sound/hdsp.h
  HDRINST usr/include/sound/usb_stream.h
  HDRINST usr/include/sound/asound.h
  HDRINST usr/include/sound/firewire.h
  HDRINST usr/include/sound/sof/header.h
  HDRINST usr/include/sound/sof/tokens.h
  HDRINST usr/include/sound/sof/fw.h
  HDRINST usr/include/sound/sof/abi.h
  HDRINST usr/include/sound/snd_sst_tokens.h
  HDRINST usr/include/sound/asequencer.h
  HDRINST usr/include/sound/asoc.h
  HDRINST usr/include/sound/compress_params.h
  HDRINST usr/include/scsi/scsi_netlink.h
  HDRINST usr/include/scsi/fc/fc_els.h
  HDRINST usr/include/scsi/fc/fc_ns.h
  HDRINST usr/include/scsi/fc/fc_fs.h
  HDRINST usr/include/scsi/fc/fc_gs.h
  HDRINST usr/include/scsi/cxlflash_ioctl.h
  HDRINST usr/include/scsi/scsi_netlink_fc.h
  HDRINST usr/include/scsi/scsi_bsg_fc.h
  HDRINST usr/include/scsi/scsi_bsg_ufs.h
  HDRINST usr/include/linux/version.h
  HDRINST usr/include/asm/posix_types.h
  HDRINST usr/include/asm/svm.h
  HDRINST usr/include/asm/kvm.h
  HDRINST usr/include/asm/mce.h
  HDRINST usr/include/asm/swab.h
  HDRINST usr/include/asm/processor-flags.h
  HDRINST usr/include/asm/ptrace-abi.h
  HDRINST usr/include/asm/sigcontext32.h
  HDRINST usr/include/asm/vmx.h
  HDRINST usr/include/asm/ldt.h
  HDRINST usr/include/asm/auxvec.h
  HDRINST usr/include/asm/msr.h
  HDRINST usr/include/asm/perf_regs.h
  HDRINST usr/include/asm/prctl.h
  HDRINST usr/include/asm/signal.h
  HDRINST usr/include/asm/e820.h
  HDRINST usr/include/asm/stat.h
  HDRINST usr/include/asm/ucontext.h
  HDRINST usr/include/asm/hwcap2.h
  HDRINST usr/include/asm/a.out.h
  HDRINST usr/include/asm/statfs.h
  HDRINST usr/include/asm/unistd.h
  HDRINST usr/include/asm/vm86.h
  HDRINST usr/include/asm/boot.h
  HDRINST usr/include/asm/bitsperlong.h
  HDRINST usr/include/asm/sembuf.h
  HDRINST usr/include/asm/kvm_perf.h
  HDRINST usr/include/asm/byteorder.h
  HDRINST usr/include/asm/hw_breakpoint.h
  HDRINST usr/include/asm/ptrace.h
  HDRINST usr/include/asm/setup.h
  HDRINST usr/include/asm/vsyscall.h
  HDRINST usr/include/asm/kvm_para.h
  HDRINST usr/include/asm/shmbuf.h
  HDRINST usr/include/asm/posix_types_32.h
  HDRINST usr/include/asm/bootparam.h
  HDRINST usr/include/asm/mtrr.h
  HDRINST usr/include/asm/posix_types_64.h
  HDRINST usr/include/asm/mman.h
  HDRINST usr/include/asm/msgbuf.h
  HDRINST usr/include/asm/ist.h
  HDRINST usr/include/asm/debugreg.h
  HDRINST usr/include/asm/sigcontext.h
  HDRINST usr/include/asm/posix_types_x32.h
  HDRINST usr/include/asm/siginfo.h
  HDRINST usr/include/asm/unistd_x32.h
  HDRINST usr/include/asm/unistd_64.h
  HDRINST usr/include/asm/unistd_32.h
  HDRINST usr/include/asm/types.h
  HDRINST usr/include/asm/termios.h
  HDRINST usr/include/asm/termbits.h
  HDRINST usr/include/asm/sockios.h
  HDRINST usr/include/asm/socket.h
  HDRINST usr/include/asm/resource.h
  HDRINST usr/include/asm/poll.h
  HDRINST usr/include/asm/param.h
  HDRINST usr/include/asm/ipcbuf.h
  HDRINST usr/include/asm/ioctls.h
  HDRINST usr/include/asm/ioctl.h
  HDRINST usr/include/asm/fcntl.h
  HDRINST usr/include/asm/errno.h
  HDRINST usr/include/asm/bpf_perf_event.h
  INSTALL ./usr/include
make[1]: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464c=
cf68e19bf7d303022d873141b5e1f7219'
make[1]: Entering directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464=
ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/dmabuf-heaps'
gcc -static -O3 -Wl,-no-as-needed -Wall -I../../../../usr/include    dmabuf=
-heap.c /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d87=
3141b5e1f7219/tools/testing/selftests/kselftest_harness.h /usr/src/perf_sel=
ftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testi=
ng/selftests/kselftest.h  -o /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464=
ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/dmabuf-heaps/dma=
buf-heap
make[1]: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464c=
cf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/dmabuf-heaps'
2020-04-09 08:13:31 make run_tests -C dmabuf-heaps
make: Entering directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf=
68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/dmabuf-heaps'
TAP version 13
1..1
# selftests: dmabuf-heaps: dmabuf-heap
# No /dev/dma_heap directory?
not ok 1 selftests: dmabuf-heaps: dmabuf-heap # exit=3D255
make: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf6=
8e19bf7d303022d873141b5e1f7219/tools/testing/selftests/dmabuf-heaps'
ignored_by_lkp efivarfs test: /sys/firmware/efi dir does not exist
2020-04-09 08:13:31 make run_tests -C exec
make: Entering directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf=
68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/exec'
gcc -Wall -Wno-nonnull -D_GNU_SOURCE    execveat.c /usr/src/perf_selftests-=
x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/self=
tests/kselftest_harness.h /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf=
68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kselftest.h  -o /us=
r/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f72=
19/tools/testing/selftests/exec/execveat
execveat.c:8:0: warning: "_GNU_SOURCE" redefined
 #define _GNU_SOURCE  /* to get O_PATH, AT_EMPTY_PATH */
=20
<command-line>:0:0: note: this is the location of the previous definition
/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1=
f7219/tools/testing/selftests/kselftest_harness.h:53:0: warning: "_GNU_SOUR=
CE" redefined
 #define _GNU_SOURCE
=20
<command-line>:0:0: note: this is the location of the previous definition
gcc -Wall -Wno-nonnull -D_GNU_SOURCE    recursion-depth.c /usr/src/perf_sel=
ftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testi=
ng/selftests/kselftest_harness.h /usr/src/perf_selftests-x86_64-rhel-7.6-d9=
d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kselftest.h =
 -o /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141=
b5e1f7219/tools/testing/selftests/exec/recursion-depth
/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1=
f7219/tools/testing/selftests/kselftest_harness.h:53:0: warning: "_GNU_SOUR=
CE" redefined
 #define _GNU_SOURCE
=20
<command-line>:0:0: note: this is the location of the previous definition
cd /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b=
5e1f7219/tools/testing/selftests/exec && ln -s -f execveat execveat.symlink
cp /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b=
5e1f7219/tools/testing/selftests/exec/execveat /usr/src/perf_selftests-x86_=
64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftest=
s/exec/execveat.denatured
chmod -x /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d8=
73141b5e1f7219/tools/testing/selftests/exec/execveat.denatured
echo '#!/bin/sh' > /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf=
7d303022d873141b5e1f7219/tools/testing/selftests/exec/script
echo 'exit $*' >> /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7=
d303022d873141b5e1f7219/tools/testing/selftests/exec/script
chmod +x /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d8=
73141b5e1f7219/tools/testing/selftests/exec/script
mkdir -p /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d8=
73141b5e1f7219/tools/testing/selftests/exec/subdir
TAP version 13
1..2
# selftests: exec: execveat
# /bin/sh: 0: Can't open /dev/fd/8/usr/src/perf_selftests-x86_64-rhel-7.6-d=
9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/exec/xxxxxx=
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=
xxxxxxxxxxxxxxxxxx/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/xxxxxx=
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=
xxxxxxxxxxxxxxxxxx/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/xxxxxx=
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=
xxxxxxxxxxxxxxxxxx/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/xxxxxx=
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=
xxxxxxxxxxxxxxxxxx/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/xxxxxx=
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=
xxxxxxxxxxxxxxxxxx/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/xxxxxx=
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=
xxxxxxxxxxxxxxxxxx/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/xxxxxx=
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy=
yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy=
yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy=
yyy
# Check success of execveat(5, '../execveat', 0)... [OK]
# Check success of execveat(7, 'execveat', 0)... [OK]
# Check success of execveat(9, 'execveat', 0)... [OK]
# Check success of execveat(-100, '/usr/src/perf_selfte...ftests/exec/execv=
eat', 0)... [OK]
# Check success of execveat(99, '/usr/src/perf_selfte...ftests/exec/execvea=
t', 0)... [OK]
# Check success of execveat(11, '', 4096)... [OK]
# Check success of execveat(20, '', 4096)... [OK]
# Check success of execveat(12, '', 4096)... [OK]
# Check success of execveat(17, '', 4096)... [OK]
# Check success of execveat(17, '', 4096)... [OK]
# Check success of execveat(18, '', 4096)... [OK]
# Check failure of execveat(11, '', 0) with ENOENT... [OK]
# Check failure of execveat(11, '(null)', 4096) with EFAULT... [OK]
# Check success of execveat(7, 'execveat.symlink', 0)... [OK]
# Check success of execveat(9, 'execveat.symlink', 0)... [OK]
# Check success of execveat(-100, '/usr/src/perf_selfte...xec/execveat.syml=
ink', 0)... [OK]
# Check success of execveat(13, '', 4096)... [OK]
# Check success of execveat(13, '', 4352)... [OK]
# Check failure of execveat(7, 'execveat.symlink', 256) with ELOOP... [OK]
# Check failure of execveat(9, 'execveat.symlink', 256) with ELOOP... [OK]
# Check failure of execveat(-100, '/usr/src/perf_selftests-x86_64-rhel-7.6-=
d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/exec/execv=
eat.symlink', 256) with ELOOP... [OK]
# Check success of execveat(5, '../script', 0)... [OK]
# Check success of execveat(7, 'script', 0)... [OK]
# Check success of execveat(9, 'script', 0)... [OK]
# Check success of execveat(-100, '/usr/src/perf_selfte...elftests/exec/scr=
ipt', 0)... [OK]
# Check success of execveat(16, '', 4096)... [OK]
# Check success of execveat(16, '', 4352)... [OK]
# Check failure of execveat(21, '', 4096) with ENOENT... [OK]
# Check failure of execveat(10, 'script', 0) with ENOENT... [OK]
# Check success of execveat(19, '', 4096)... [OK]
# Check success of execveat(19, '', 4096)... [OK]
# Check success of execveat(6, '../script', 0)... [OK]
# Check success of execveat(6, 'script', 0)... [OK]
# Check success of execveat(6, '../script', 0)... [OK]
# Check failure of execveat(6, 'script', 0) with ENOENT... [OK]
# Check failure of execveat(7, 'execveat', 65535) with EINVAL... [OK]
# Check failure of execveat(7, 'no-such-file', 0) with ENOENT... [OK]
# Check failure of execveat(9, 'no-such-file', 0) with ENOENT... [OK]
# Check failure of execveat(-100, 'no-such-file', 0) with ENOENT... [OK]
# Check failure of execveat(7, '', 4096) with EACCES... [OK]
# Check failure of execveat(7, 'Makefile', 0) with EACCES... [OK]
# Check failure of execveat(14, '', 4096) with EACCES... [OK]
# Check failure of execveat(15, '', 4096) with EACCES... [OK]
# Check failure of execveat(99, '', 4096) with EBADF... [OK]
# Check failure of execveat(99, 'execveat', 0) with EBADF... [OK]
# Check failure of execveat(11, 'execveat', 0) with ENOTDIR... [OK]
# Invoke copy of 'execveat' via filename of length 4094:
# Check success of execveat(22, '', 4096)... [OK]
# Check success of execveat(8, 'usr/src/perf_selftes...yyyyyyyyyyyyyyyyyyyy=
', 0)... [OK]
# Invoke copy of 'script' via filename of length 4094:
# Check success of execveat(23, '', 4096)... [OK]
# Check success of execveat(8, 'usr/src/perf_selftes...yyyyyyyyyyyyyyyyyyyy=
', 0)... [OK]
ok 1 selftests: exec: execveat
# selftests: exec: recursion-depth
ok 2 selftests: exec: recursion-depth
make: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf6=
8e19bf7d303022d873141b5e1f7219/tools/testing/selftests/exec'
ignored_by_lkp filesystems test
2020-04-09 08:13:31 mv /lib/udev/rules.d/50-firmware.rules .
2020-04-09 08:13:31 /etc/init.d/udev restart
Restarting udev (via systemctl): udev.service.
2020-04-09 08:13:32 make run_tests -C firmware
make: Entering directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf=
68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/firmware'
TAP version 13
1..1
# selftests: firmware: fw_run_tests.sh
# -----------------------------------------------------
# Running kernel configuration test 1 -- rare
# Emulates:
# CONFIG_FW_LOADER=3Dy
# CONFIG_FW_LOADER_USER_HELPER=3Dn
# CONFIG_FW_LOADER_USER_HELPER_FALLBACK=3Dn
# ./fw_filesystem.sh: filesystem loading works
# ./fw_filesystem.sh: async filesystem loading works
#=20
# Testing with the file present...
# Batched request_firmware() normal try #1: OK
# Batched request_firmware() normal try #2: OK
# Batched request_firmware() normal try #3: OK
# Batched request_firmware() normal try #4: OK
# Batched request_firmware() normal try #5: OK
# Batched request_firmware_into_buf() normal try #1: OK
# Batched request_firmware_into_buf() normal try #2: OK
# Batched request_firmware_into_buf() normal try #3: OK
# Batched request_firmware_into_buf() normal try #4: OK
# Batched request_firmware_into_buf() normal try #5: OK
# Batched request_firmware_direct() normal try #1: OK
# Batched request_firmware_direct() normal try #2: OK
# Batched request_firmware_direct() normal try #3: OK
# Batched request_firmware_direct() normal try #4: OK
# Batched request_firmware_direct() normal try #5: OK
# Batched request_firmware_nowait(uevent=3Dtrue) normal try #1: OK
# Batched request_firmware_nowait(uevent=3Dtrue) normal try #2: OK
# Batched request_firmware_nowait(uevent=3Dtrue) normal try #3: OK
# Batched request_firmware_nowait(uevent=3Dtrue) normal try #4: OK
# Batched request_firmware_nowait(uevent=3Dtrue) normal try #5: OK
# Batched request_firmware_nowait(uevent=3Dfalse) normal try #1: OK
# Batched request_firmware_nowait(uevent=3Dfalse) normal try #2: OK
# Batched request_firmware_nowait(uevent=3Dfalse) normal try #3: OK
# Batched request_firmware_nowait(uevent=3Dfalse) normal try #4: OK
# Batched request_firmware_nowait(uevent=3Dfalse) normal try #5: OK
#=20
# Testing with the file missing...
# Batched request_firmware() nofile try #1: OK
# Batched request_firmware() nofile try #2: OK
# Batched request_firmware() nofile try #3: OK
# Batched request_firmware() nofile try #4: OK
# Batched request_firmware() nofile try #5: OK
# Batched request_firmware_into_buf() nofile try #1: OK
# Batched request_firmware_into_buf() nofile try #2: OK
# Batched request_firmware_into_buf() nofile try #3: OK
# Batched request_firmware_into_buf() nofile try #4: OK
# Batched request_firmware_into_buf() nofile try #5: OK
# Batched request_firmware_direct() nofile try #1: OK
# Batched request_firmware_direct() nofile try #2: OK
# Batched request_firmware_direct() nofile try #3: OK
# Batched request_firmware_direct() nofile try #4: OK
# Batched request_firmware_direct() nofile try #5: OK
# Batched request_firmware_nowait(uevent=3Dtrue) nofile try #1: OK
# Batched request_firmware_nowait(uevent=3Dtrue) nofile try #2: OK
# Batched request_firmware_nowait(uevent=3Dtrue) nofile try #3: OK
# Batched request_firmware_nowait(uevent=3Dtrue) nofile try #4: OK
# Batched request_firmware_nowait(uevent=3Dtrue) nofile try #5: OK
# Batched request_firmware_nowait(uevent=3Dfalse) nofile try #1: OK
# Batched request_firmware_nowait(uevent=3Dfalse) nofile try #2: OK
# Batched request_firmware_nowait(uevent=3Dfalse) nofile try #3: OK
# Batched request_firmware_nowait(uevent=3Dfalse) nofile try #4: OK
# Batched request_firmware_nowait(uevent=3Dfalse) nofile try #5: OK
# usermode helper disabled so ignoring test
# -----------------------------------------------------
# Running kernel configuration test 2 -- distro
# Emulates:
# CONFIG_FW_LOADER=3Dy
# CONFIG_FW_LOADER_USER_HELPER=3Dy
# CONFIG_FW_LOADER_USER_HELPER_FALLBACK=3Dn
# ./fw_filesystem.sh: timeout works
# ./fw_filesystem.sh: filesystem loading works
# ./fw_filesystem.sh: async filesystem loading works
#=20
# Testing with the file present...
# Batched request_firmware() normal try #1: OK
# Batched request_firmware() normal try #2: OK
# Batched request_firmware() normal try #3: OK
# Batched request_firmware() normal try #4: OK
# Batched request_firmware() normal try #5: OK
# Batched request_firmware_into_buf() normal try #1: OK
# Batched request_firmware_into_buf() normal try #2: OK
# Batched request_firmware_into_buf() normal try #3: OK
# Batched request_firmware_into_buf() normal try #4: OK
# Batched request_firmware_into_buf() normal try #5: OK
# Batched request_firmware_direct() normal try #1: OK
# Batched request_firmware_direct() normal try #2: OK
# Batched request_firmware_direct() normal try #3: OK
# Batched request_firmware_direct() normal try #4: OK
# Batched request_firmware_direct() normal try #5: OK
# Batched request_firmware_nowait(uevent=3Dtrue) normal try #1: OK
# Batched request_firmware_nowait(uevent=3Dtrue) normal try #2: OK
# Batched request_firmware_nowait(uevent=3Dtrue) normal try #3: OK
# Batched request_firmware_nowait(uevent=3Dtrue) normal try #4: OK
# Batched request_firmware_nowait(uevent=3Dtrue) normal try #5: OK
# Batched request_firmware_nowait(uevent=3Dfalse) normal try #1: OK
# Batched request_firmware_nowait(uevent=3Dfalse) normal try #2: OK
# Batched request_firmware_nowait(uevent=3Dfalse) normal try #3: OK
# Batched request_firmware_nowait(uevent=3Dfalse) normal try #4: OK
# Batched request_firmware_nowait(uevent=3Dfalse) normal try #5: OK
#=20
# Testing with the file missing...
# Batched request_firmware() nofile try #1: OK
# Batched request_firmware() nofile try #2: OK
# Batched request_firmware() nofile try #3: OK
# Batched request_firmware() nofile try #4: OK
# Batched request_firmware() nofile try #5: OK
# Batched request_firmware_into_buf() nofile try #1: OK
# Batched request_firmware_into_buf() nofile try #2: OK
# Batched request_firmware_into_buf() nofile try #3: OK
# Batched request_firmware_into_buf() nofile try #4: OK
# Batched request_firmware_into_buf() nofile try #5: OK
# Batched request_firmware_direct() nofile try #1: OK
# Batched request_firmware_direct() nofile try #2: OK
# Batched request_firmware_direct() nofile try #3: OK
# Batched request_firmware_direct() nofile try #4: OK
# Batched request_firmware_direct() nofile try #5: OK
# Batched request_firmware_nowait(uevent=3Dtrue) nofile try #1: OK
# Batched request_firmware_nowait(uevent=3Dtrue) nofile try #2: OK
# Batched request_firmware_nowait(uevent=3Dtrue) nofile try #3: OK
# Batched request_firmware_nowait(uevent=3Dtrue) nofile try #4: OK
# Batched request_firmware_nowait(uevent=3Dtrue) nofile try #5: OK
# Batched request_firmware_nowait(uevent=3Dfalse) nofile try #1: OK
# Batched request_firmware_nowait(uevent=3Dfalse) nofile try #2: OK
# Batched request_firmware_nowait(uevent=3Dfalse) nofile try #3: OK
# Batched request_firmware_nowait(uevent=3Dfalse) nofile try #4: OK
# Batched request_firmware_nowait(uevent=3Dfalse) nofile try #5: OK
# ./fw_fallback.sh: custom fallback loading mechanism works
# ./fw_fallback.sh: custom fallback loading mechanism works
# ./fw_fallback.sh: cancelling custom fallback mechanism works
# -----------------------------------------------------
# Running kernel configuration test 3 -- android
# Emulates:
# CONFIG_FW_LOADER=3Dy
# CONFIG_FW_LOADER_USER_HELPER=3Dy
# CONFIG_FW_LOADER_USER_HELPER_FALLBACK=3Dy
# ./fw_filesystem.sh: timeout works
# ./fw_filesystem.sh: filesystem loading works
# ./fw_filesystem.sh: async filesystem loading works
#=20
# Testing with the file present...
# Batched request_firmware() normal try #1: OK
# Batched request_firmware() normal try #2: OK
# Batched request_firmware() normal try #3: OK
# Batched request_firmware() normal try #4: OK
# Batched request_firmware() normal try #5: OK
# Batched request_firmware_into_buf() normal try #1: OK
# Batched request_firmware_into_buf() normal try #2: OK
# Batched request_firmware_into_buf() normal try #3: OK
# Batched request_firmware_into_buf() normal try #4: OK
# Batched request_firmware_into_buf() normal try #5: OK
# Batched request_firmware_direct() normal try #1: OK
# Batched request_firmware_direct() normal try #2: OK
# Batched request_firmware_direct() normal try #3: OK
# Batched request_firmware_direct() normal try #4: OK
# Batched request_firmware_direct() normal try #5: OK
# Batched request_firmware_nowait(uevent=3Dtrue) normal try #1: OK
# Batched request_firmware_nowait(uevent=3Dtrue) normal try #2: OK
# Batched request_firmware_nowait(uevent=3Dtrue) normal try #3: OK
# Batched request_firmware_nowait(uevent=3Dtrue) normal try #4: OK
# Batched request_firmware_nowait(uevent=3Dtrue) normal try #5: OK
# Batched request_firmware_nowait(uevent=3Dfalse) normal try #1: OK
# Batched request_firmware_nowait(uevent=3Dfalse) normal try #2: OK
# Batched request_firmware_nowait(uevent=3Dfalse) normal try #3: OK
# Batched request_firmware_nowait(uevent=3Dfalse) normal try #4: OK
# Batched request_firmware_nowait(uevent=3Dfalse) normal try #5: OK
#=20
# Testing with the file missing...
# Batched request_firmware() nofile try #1: OK
# Batched request_firmware() nofile try #2: OK
# Batched request_firmware() nofile try #3: OK
# Batched request_firmware() nofile try #4: OK
# Batched request_firmware() nofile try #5: OK
# Batched request_firmware_into_buf() nofile try #1: OK
# Batched request_firmware_into_buf() nofile try #2: OK
# Batched request_firmware_into_buf() nofile try #3: OK
# Batched request_firmware_into_buf() nofile try #4: OK
# Batched request_firmware_into_buf() nofile try #5: OK
# Batched request_firmware_direct() nofile try #1: OK
# Batched request_firmware_direct() nofile try #2: OK
# Batched request_firmware_direct() nofile try #3: OK
# Batched request_firmware_direct() nofile try #4: OK
# Batched request_firmware_direct() nofile try #5: OK
# Batched request_firmware_nowait(uevent=3Dtrue) nofile try #1: OK
# Batched request_firmware_nowait(uevent=3Dtrue) nofile try #2: OK
# Batched request_firmware_nowait(uevent=3Dtrue) nofile try #3: OK
# Batched request_firmware_nowait(uevent=3Dtrue) nofile try #4: OK
# Batched request_firmware_nowait(uevent=3Dtrue) nofile try #5: OK
# Batched request_firmware_nowait(uevent=3Dfalse) nofile try #1: OK
# Batched request_firmware_nowait(uevent=3Dfalse) nofile try #2: OK
# Batched request_firmware_nowait(uevent=3Dfalse) nofile try #3: OK
# Batched request_firmware_nowait(uevent=3Dfalse) nofile try #4: OK
# Batched request_firmware_nowait(uevent=3Dfalse) nofile try #5: OK
# ./fw_fallback.sh: timeout works
# ./fw_fallback.sh: firmware comparison works
# ./fw_fallback.sh: fallback mechanism works
# ./fw_fallback.sh: cancelling fallback mechanism works
# ./fw_fallback.sh: SIGCHLD on sync ignored as expected
# ./fw_fallback.sh: custom fallback loading mechanism works
# ./fw_fallback.sh: custom fallback loading mechanism works
# ./fw_fallback.sh: cancelling custom fallback mechanism works
ok 1 selftests: firmware: fw_run_tests.sh
make: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf6=
8e19bf7d303022d873141b5e1f7219/tools/testing/selftests/firmware'
2020-04-09 08:16:09 mv 50-firmware.rules /lib/udev/rules.d/50-firmware.rules
2020-04-09 08:16:09 make run_tests -C ftrace
make: Entering directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf=
68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/ftrace'
TAP version 13
1..1
# selftests: ftrace: ftracetest
# =3D=3D=3D Ftrace unit tests =3D=3D=3D
# [1] Basic trace file check	[PASS]
# [2] Basic test for tracers	[PASS]
# [3] Basic trace clock test	[PASS]
# [4] Basic event tracing check	[PASS]
# [5] Change the ringbuffer size	[PASS]
# [6] Snapshot and tracing setting	[PASS]
# [7] trace_pipe and trace_marker	[PASS]
# [8] Test ftrace direct functions against tracers	[UNRESOLVED]
# [9] Test ftrace direct functions against kprobes	[UNRESOLVED]
# [10] Generic dynamic event - add/remove kprobe events	[PASS]
# [11] Generic dynamic event - add/remove synthetic events	[PASS]
# [12] Generic dynamic event - selective clear (compatibility)	[PASS]
# [13] Generic dynamic event - generic clear event	[PASS]
# [14] event tracing - enable/disable with event level files	[PASS]
# [15] event tracing - restricts events based on pid	[PASS]
# [16] event tracing - enable/disable with subsystem level files	[PASS]
# [17] event tracing - enable/disable with top level files	[PASS]
# [18] Test trace_printk from module	[UNRESOLVED]
# [19] ftrace - function graph filters with stack tracer	[PASS]
# [20] ftrace - function graph filters	[PASS]
# [21] ftrace - function glob filters	[PASS]
# [22] ftrace - function pid filters	[PASS]
# [23] ftrace - stacktrace filter command	[PASS]
# [24] ftrace - function trace with cpumask	[PASS]
# [25] ftrace - test for function event triggers	[PASS]
# [26] ftrace - function trace on module	[UNRESOLVED]
# [27] ftrace - function profiling	[PASS]
# [28] ftrace - function profiler with function tracing	[PASS]
# [29] ftrace - test reading of set_ftrace_filter	[PASS]
# [30] ftrace - Max stack tracer	[PASS]
# [31] ftrace - test for function traceon/off triggers	[PASS]
# [32] ftrace - test tracing error log support	[PASS]
# [33] Test creation and deletion of trace instances while setting an event=
	[PASS]
# [34] Test creation and deletion of trace instances	[PASS]
# [35] Kprobe dynamic event - adding and removing	[PASS]
# [36] Kprobe dynamic event - busy event check	[PASS]
# [37] Kprobe dynamic event with arguments	[PASS]
# [38] Kprobe event with comm arguments	[PASS]
# [39] Kprobe event string type argument	[PASS]
# [40] Kprobe event symbol argument	[PASS]
# [41] Kprobe event argument syntax	[PASS]
# [42] Kprobes event arguments with types	[PASS]
# [43] Kprobe event user-memory access	[PASS]
# [44] Kprobe event auto/manual naming	[PASS]
# [45] Kprobe dynamic event with function tracer	[PASS]
# [46] Kprobe dynamic event - probing module	[UNRESOLVED]
# [47] Create/delete multiprobe on kprobe event	[PASS]
# [48] Kprobe event parser error log check	[FAIL]
# [49] Kretprobe dynamic event with arguments	[PASS]
# [50] Kretprobe dynamic event with maxactive	[PASS]
# [51] Register/unregister many kprobe events	[PASS]
# [52] Kprobe events - probe points	[PASS]
# [53] Kprobe dynamic event - adding and removing	[PASS]
# [54] Uprobe event parser error log check	[PASS]
# [55] test for the preemptirqsoff tracer	[UNSUPPORTED]
# [56] Meta-selftest	[UNRESOLVED]
# [57] Test wakeup tracer	[PASS]
# [58] Test wakeup RT tracer	[PASS]
# [59] event trigger - test inter-event histogram trigger expected fail act=
ions	[XFAIL]
# [60] event trigger - test field variable support	[PASS]
# [61] event trigger - test inter-event combined histogram trigger	[PASS]
# [62] event trigger - test multiple actions on hist trigger	[PASS]
# [63] event trigger - test inter-event histogram trigger onchange action	[=
PASS]
# [64] event trigger - test inter-event histogram trigger onmatch action	[P=
ASS]
# [65] event trigger - test inter-event histogram trigger onmatch-onmax act=
ion	[PASS]
# [66] event trigger - test inter-event histogram trigger onmax action	[PAS=
S]
# [67] event trigger - test inter-event histogram trigger snapshot action	[=
PASS]
# [68] event trigger - test synthetic event create remove	[PASS]
# [69] event trigger - test synthetic_events syntax parser	[PASS]
# [70] event trigger - test inter-event histogram trigger trace action	[PAS=
S]
# [71] event trigger - test event enable/disable trigger	[PASS]
# [72] event trigger - test trigger filter	[PASS]
# [73] event trigger - test histogram modifiers	[PASS]
# [74] event trigger - test histogram parser errors	[PASS]
# [75] event trigger - test histogram trigger	[PASS]
# [76] event trigger - test multiple histogram triggers	[PASS]
# [77] event trigger - test snapshot-trigger	[PASS]
# [78] event trigger - test stacktrace-trigger	[PASS]
# [79] trace_marker trigger - test histogram trigger	[PASS]
# [80] trace_marker trigger - test snapshot trigger	[PASS]
# [81] trace_marker trigger - test histogram with synthetic event against k=
ernel event	[PASS]
# [82] trace_marker trigger - test histogram with synthetic event	[PASS]
# [83] event trigger - test traceon/off trigger	[PASS]
# [84] (instance)  Basic test for tracers	[PASS]
# [85] (instance)  Basic trace clock test	[PASS]
# [86] (instance)  Change the ringbuffer size	[PASS]
# [87] (instance)  Snapshot and tracing setting	[PASS]
# [88] (instance)  trace_pipe and trace_marker	[PASS]
# [89] (instance)  event tracing - enable/disable with event level files	[P=
ASS]
# [90] (instance)  event tracing - restricts events based on pid	[PASS]
# [91] (instance)  event tracing - enable/disable with subsystem level file=
s	[PASS]
# [92] (instance)  ftrace - stacktrace filter command	[PASS]
# [93] (instance)  ftrace - test for function event triggers	[PASS]
# [94] (instance)  ftrace - test for function traceon/off triggers	[PASS]
# [95] (instance)  event trigger - test event enable/disable trigger	[PASS]
# [96] (instance)  event trigger - test trigger filter	[PASS]
# [97] (instance)  event trigger - test histogram modifiers	[PASS]
# [98] (instance)  event trigger - test histogram trigger	[PASS]
# [99] (instance)  event trigger - test multiple histogram triggers	[PASS]
# [100] (instance)  trace_marker trigger - test histogram trigger	[PASS]
# [101] (instance)  trace_marker trigger - test snapshot trigger	[PASS]
#=20
#=20
# # of passed:  92
# # of failed:  1
# # of unresolved:  6
# # of untested:  0
# # of unsupported:  1
# # of xfailed:  1
# # of undefined(test bug):  0
not ok 1 selftests: ftrace: ftracetest # exit=3D1
make: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf6=
8e19bf7d303022d873141b5e1f7219/tools/testing/selftests/ftrace'
2020-04-09 08:18:56 make run_tests -C futex
make: Entering directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf=
68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/futex'
make[1]: Entering directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464=
ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/futex/functional'
make --no-builtin-rules INSTALL_HDR_PATH=3D$OUTPUT/usr \
	ARCH=3Dx86 -C ../../../../.. headers_install
make[2]: Entering directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464=
ccf68e19bf7d303022d873141b5e1f7219'
  INSTALL /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d=
873141b5e1f7219/tools/testing/selftests/futex/functional/usr/include
make[2]: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464c=
cf68e19bf7d303022d873141b5e1f7219'
gcc  -g -O2 -Wall -D_GNU_SOURCE -pthread -I../include -I../../   -pthread -=
lrt  futex_wait_timeout.c /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf=
68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kselftest_harness.h=
 /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e=
1f7219/tools/testing/selftests/kselftest.h ../include/futextest.h ../includ=
e/atomic.h ../include/logging.h  -o /usr/src/perf_selftests-x86_64-rhel-7.6=
-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/futex/fun=
ctional/futex_wait_timeout
/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1=
f7219/tools/testing/selftests/kselftest_harness.h:53:0: warning: "_GNU_SOUR=
CE" redefined
 #define _GNU_SOURCE
=20
<command-line>:0:0: note: this is the location of the previous definition
gcc  -g -O2 -Wall -D_GNU_SOURCE -pthread -I../include -I../../   -pthread -=
lrt  futex_wait_wouldblock.c /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464=
ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kselftest_harnes=
s.h /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141=
b5e1f7219/tools/testing/selftests/kselftest.h ../include/futextest.h ../inc=
lude/atomic.h ../include/logging.h  -o /usr/src/perf_selftests-x86_64-rhel-=
7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/futex/=
functional/futex_wait_wouldblock
/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1=
f7219/tools/testing/selftests/kselftest_harness.h:53:0: warning: "_GNU_SOUR=
CE" redefined
 #define _GNU_SOURCE
=20
<command-line>:0:0: note: this is the location of the previous definition
gcc  -g -O2 -Wall -D_GNU_SOURCE -pthread -I../include -I../../   -pthread -=
lrt  futex_requeue_pi.c /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68=
e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kselftest_harness.h /=
usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f=
7219/tools/testing/selftests/kselftest.h ../include/futextest.h ../include/=
atomic.h ../include/logging.h  -o /usr/src/perf_selftests-x86_64-rhel-7.6-d=
9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/futex/funct=
ional/futex_requeue_pi
/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1=
f7219/tools/testing/selftests/kselftest_harness.h:53:0: warning: "_GNU_SOUR=
CE" redefined
 #define _GNU_SOURCE
=20
<command-line>:0:0: note: this is the location of the previous definition
gcc  -g -O2 -Wall -D_GNU_SOURCE -pthread -I../include -I../../   -pthread -=
lrt  futex_requeue_pi_signal_restart.c /usr/src/perf_selftests-x86_64-rhel-=
7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kselft=
est_harness.h /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303=
022d873141b5e1f7219/tools/testing/selftests/kselftest.h ../include/futextes=
t.h ../include/atomic.h ../include/logging.h  -o /usr/src/perf_selftests-x8=
6_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selfte=
sts/futex/functional/futex_requeue_pi_signal_restart
/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1=
f7219/tools/testing/selftests/kselftest_harness.h:53:0: warning: "_GNU_SOUR=
CE" redefined
 #define _GNU_SOURCE
=20
<command-line>:0:0: note: this is the location of the previous definition
gcc  -g -O2 -Wall -D_GNU_SOURCE -pthread -I../include -I../../   -pthread -=
lrt  futex_requeue_pi_mismatched_ops.c /usr/src/perf_selftests-x86_64-rhel-=
7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kselft=
est_harness.h /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303=
022d873141b5e1f7219/tools/testing/selftests/kselftest.h ../include/futextes=
t.h ../include/atomic.h ../include/logging.h  -o /usr/src/perf_selftests-x8=
6_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selfte=
sts/futex/functional/futex_requeue_pi_mismatched_ops
/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1=
f7219/tools/testing/selftests/kselftest_harness.h:53:0: warning: "_GNU_SOUR=
CE" redefined
 #define _GNU_SOURCE
=20
<command-line>:0:0: note: this is the location of the previous definition
gcc  -g -O2 -Wall -D_GNU_SOURCE -pthread -I../include -I../../   -pthread -=
lrt  futex_wait_uninitialized_heap.c /usr/src/perf_selftests-x86_64-rhel-7.=
6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kselftes=
t_harness.h /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d30302=
2d873141b5e1f7219/tools/testing/selftests/kselftest.h ../include/futextest.=
h ../include/atomic.h ../include/logging.h  -o /usr/src/perf_selftests-x86_=
64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftest=
s/futex/functional/futex_wait_uninitialized_heap
/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1=
f7219/tools/testing/selftests/kselftest_harness.h:53:0: warning: "_GNU_SOUR=
CE" redefined
 #define _GNU_SOURCE
=20
<command-line>:0:0: note: this is the location of the previous definition
gcc  -g -O2 -Wall -D_GNU_SOURCE -pthread -I../include -I../../   -pthread -=
lrt  futex_wait_private_mapped_file.c /usr/src/perf_selftests-x86_64-rhel-7=
=2E6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kself=
test_harness.h /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d30=
3022d873141b5e1f7219/tools/testing/selftests/kselftest.h ../include/futexte=
st.h ../include/atomic.h ../include/logging.h  -o /usr/src/perf_selftests-x=
86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selft=
ests/futex/functional/futex_wait_private_mapped_file
/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1=
f7219/tools/testing/selftests/kselftest_harness.h:53:0: warning: "_GNU_SOUR=
CE" redefined
 #define _GNU_SOURCE
=20
<command-line>:0:0: note: this is the location of the previous definition
make[1]: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464c=
cf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/futex/functional'
TAP version 13
1..1
# selftests: futex: run.sh
#=20
# TAP version 13
# 1..1
# # futex_requeue_pi: Test requeue functionality
# # 	Arguments: broadcast=3D0 locked=3D0 owner=3D0 timeout=3D0ns
# ok 1 futex-requeue-pi
# # Pass 1 Fail 0 Xfail 0 Xpass 0 Skip 0 Error 0
# TAP version 13
# 1..1
# # futex_requeue_pi: Test requeue functionality
# # 	Arguments: broadcast=3D1 locked=3D0 owner=3D0 timeout=3D0ns
# ok 1 futex-requeue-pi
# # Pass 1 Fail 0 Xfail 0 Xpass 0 Skip 0 Error 0
# TAP version 13
# 1..1
# # futex_requeue_pi: Test requeue functionality
# # 	Arguments: broadcast=3D1 locked=3D1 owner=3D0 timeout=3D0ns
# ok 1 futex-requeue-pi
# # Pass 1 Fail 0 Xfail 0 Xpass 0 Skip 0 Error 0
# TAP version 13
# 1..1
# # futex_requeue_pi: Test requeue functionality
# # 	Arguments: broadcast=3D1 locked=3D0 owner=3D1 timeout=3D0ns
# ok 1 futex-requeue-pi
# # Pass 1 Fail 0 Xfail 0 Xpass 0 Skip 0 Error 0
# TAP version 13
# 1..1
# # futex_requeue_pi: Test requeue functionality
# # 	Arguments: broadcast=3D0 locked=3D1 owner=3D0 timeout=3D0ns
# ok 1 futex-requeue-pi
# # Pass 1 Fail 0 Xfail 0 Xpass 0 Skip 0 Error 0
# TAP version 13
# 1..1
# # futex_requeue_pi: Test requeue functionality
# # 	Arguments: broadcast=3D0 locked=3D0 owner=3D1 timeout=3D0ns
# ok 1 futex-requeue-pi
# # Pass 1 Fail 0 Xfail 0 Xpass 0 Skip 0 Error 0
# TAP version 13
# 1..1
# # futex_requeue_pi: Test requeue functionality
# # 	Arguments: broadcast=3D1 locked=3D1 owner=3D0 timeout=3D5000ns
# ok 1 futex-requeue-pi
# # Pass 1 Fail 0 Xfail 0 Xpass 0 Skip 0 Error 0
# TAP version 13
# 1..1
# # futex_requeue_pi: Test requeue functionality
# # 	Arguments: broadcast=3D0 locked=3D1 owner=3D0 timeout=3D5000ns
# ok 1 futex-requeue-pi
# # Pass 1 Fail 0 Xfail 0 Xpass 0 Skip 0 Error 0
# TAP version 13
# 1..1
# # futex_requeue_pi: Test requeue functionality
# # 	Arguments: broadcast=3D1 locked=3D1 owner=3D0 timeout=3D500000ns
# ok 1 futex-requeue-pi
# # Pass 1 Fail 0 Xfail 0 Xpass 0 Skip 0 Error 0
# TAP version 13
# 1..1
# # futex_requeue_pi: Test requeue functionality
# # 	Arguments: broadcast=3D0 locked=3D1 owner=3D0 timeout=3D500000ns
# ok 1 futex-requeue-pi
# # Pass 1 Fail 0 Xfail 0 Xpass 0 Skip 0 Error 0
# TAP version 13
# 1..1
# # futex_requeue_pi: Test requeue functionality
# # 	Arguments: broadcast=3D1 locked=3D0 owner=3D0 timeout=3D5000ns
# ok 1 futex-requeue-pi
# # Pass 1 Fail 0 Xfail 0 Xpass 0 Skip 0 Error 0
# TAP version 13
# 1..1
# # futex_requeue_pi: Test requeue functionality
# # 	Arguments: broadcast=3D0 locked=3D0 owner=3D0 timeout=3D5000ns
# ok 1 futex-requeue-pi
# # Pass 1 Fail 0 Xfail 0 Xpass 0 Skip 0 Error 0
# TAP version 13
# 1..1
# # futex_requeue_pi: Test requeue functionality
# # 	Arguments: broadcast=3D1 locked=3D0 owner=3D0 timeout=3D500000ns
# ok 1 futex-requeue-pi
# # Pass 1 Fail 0 Xfail 0 Xpass 0 Skip 0 Error 0
# TAP version 13
# 1..1
# # futex_requeue_pi: Test requeue functionality
# # 	Arguments: broadcast=3D0 locked=3D0 owner=3D0 timeout=3D500000ns
# ok 1 futex-requeue-pi
# # Pass 1 Fail 0 Xfail 0 Xpass 0 Skip 0 Error 0
# TAP version 13
# 1..1
# # futex_requeue_pi: Test requeue functionality
# # 	Arguments: broadcast=3D1 locked=3D0 owner=3D1 timeout=3D5000ns
# ok 1 futex-requeue-pi
# # Pass 1 Fail 0 Xfail 0 Xpass 0 Skip 0 Error 0
# TAP version 13
# 1..1
# # futex_requeue_pi: Test requeue functionality
# # 	Arguments: broadcast=3D0 locked=3D1 owner=3D0 timeout=3D5000ns
# ok 1 futex-requeue-pi
# # Pass 1 Fail 0 Xfail 0 Xpass 0 Skip 0 Error 0
# TAP version 13
# 1..1
# # futex_requeue_pi: Test requeue functionality
# # 	Arguments: broadcast=3D1 locked=3D0 owner=3D1 timeout=3D500000ns
# ok 1 futex-requeue-pi
# # Pass 1 Fail 0 Xfail 0 Xpass 0 Skip 0 Error 0
# TAP version 13
# 1..1
# # futex_requeue_pi: Test requeue functionality
# # 	Arguments: broadcast=3D0 locked=3D1 owner=3D0 timeout=3D500000ns
# ok 1 futex-requeue-pi
# # Pass 1 Fail 0 Xfail 0 Xpass 0 Skip 0 Error 0
# TAP version 13
# 1..1
# # futex_requeue_pi: Test requeue functionality
# # 	Arguments: broadcast=3D1 locked=3D1 owner=3D0 timeout=3D2000000000ns
# ok 1 futex-requeue-pi
# # Pass 1 Fail 0 Xfail 0 Xpass 0 Skip 0 Error 0
# TAP version 13
# 1..1
# # futex_requeue_pi: Test requeue functionality
# # 	Arguments: broadcast=3D0 locked=3D1 owner=3D0 timeout=3D2000000000ns
# ok 1 futex-requeue-pi
# # Pass 1 Fail 0 Xfail 0 Xpass 0 Skip 0 Error 0
#=20
# TAP version 13
# 1..1
# # futex_requeue_pi_mismatched_ops: Detect mismatched requeue_pi operations
# ok 1 futex-requeue-pi-mismatched-ops
# # Pass 1 Fail 0 Xfail 0 Xpass 0 Skip 0 Error 0
#=20
# TAP version 13
# 1..1
# # futex_requeue_pi_signal_restart: Test signal handling during requeue_pi
# # 	Arguments: <none>
# ok 1 futex-requeue-pi-signal-restart
# # Pass 1 Fail 0 Xfail 0 Xpass 0 Skip 0 Error 0
#=20
# TAP version 13
# 1..1
# # futex_wait_timeout: Block on a futex and wait for timeout
# # 	Arguments: timeout=3D100000ns
# ok 1 futex-wait-timeout
# # Pass 1 Fail 0 Xfail 0 Xpass 0 Skip 0 Error 0
#=20
# TAP version 13
# 1..1
# # futex_wait_wouldblock: Test the unexpected futex value in FUTEX_WAIT
# ok 1 futex-wait-wouldblock
# # Pass 1 Fail 0 Xfail 0 Xpass 0 Skip 0 Error 0
#=20
# TAP version 13
# 1..1
# # futex_wait_uninitialized_heap: Test the uninitialized futex value in FU=
TEX_WAIT
# ok 1 futex-wait-uninitialized-heap
# # Pass 1 Fail 0 Xfail 0 Xpass 0 Skip 0 Error 0
# TAP version 13
# 1..1
# # futex_wait_private_mapped_file: Test the futex value of private file ma=
ppings in FUTEX_WAIT
# ok 1 futex-wait-private-mapped-file
# # Pass 1 Fail 0 Xfail 0 Xpass 0 Skip 0 Error 0
ok 1 selftests: futex: run.sh
make: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf6=
8e19bf7d303022d873141b5e1f7219/tools/testing/selftests/futex'
2020-04-09 08:19:10 make -C ../../../tools/gpio
make: Entering directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf=
68e19bf7d303022d873141b5e1f7219/tools/gpio'
mkdir -p include/linux 2>&1 || true
ln -sf /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873=
141b5e1f7219/tools/gpio/../../include/uapi/linux/gpio.h include/linux/gpio.h
make -f /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d87=
3141b5e1f7219/tools/build/Makefile.build dir=3D. obj=3Dgpio-utils
make[1]: Entering directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464=
ccf68e19bf7d303022d873141b5e1f7219/tools/gpio'
  CC       gpio-utils.o
  LD       gpio-utils-in.o
make[1]: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464c=
cf68e19bf7d303022d873141b5e1f7219/tools/gpio'
make -f /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d87=
3141b5e1f7219/tools/build/Makefile.build dir=3D. obj=3Dlsgpio
make[1]: Entering directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464=
ccf68e19bf7d303022d873141b5e1f7219/tools/gpio'
  CC       lsgpio.o
  LD       lsgpio-in.o
make[1]: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464c=
cf68e19bf7d303022d873141b5e1f7219/tools/gpio'
  LINK     lsgpio
make -f /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d87=
3141b5e1f7219/tools/build/Makefile.build dir=3D. obj=3Dgpio-hammer
make[1]: Entering directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464=
ccf68e19bf7d303022d873141b5e1f7219/tools/gpio'
  CC       gpio-hammer.o
  LD       gpio-hammer-in.o
make[1]: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464c=
cf68e19bf7d303022d873141b5e1f7219/tools/gpio'
  LINK     gpio-hammer
make -f /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d87=
3141b5e1f7219/tools/build/Makefile.build dir=3D. obj=3Dgpio-event-mon
make[1]: Entering directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464=
ccf68e19bf7d303022d873141b5e1f7219/tools/gpio'
  CC       gpio-event-mon.o
  LD       gpio-event-mon-in.o
make[1]: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464c=
cf68e19bf7d303022d873141b5e1f7219/tools/gpio'
  LINK     gpio-event-mon
make: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf6=
8e19bf7d303022d873141b5e1f7219/tools/gpio'
2020-04-09 08:19:10 make run_tests -C gpio
make: Entering directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf=
68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/gpio'
gcc -O2 -g -std=3Dgnu99 -Wall -I../../../../usr/include/ -I/usr/include/lib=
mount -I/usr/include/blkid -I/usr/include/uuid    gpio-mockup-chardev.c /us=
r/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f72=
19/tools/gpio/gpio-utils.o  -lmount -o gpio-mockup-chardev
make --no-builtin-rules ARCH=3Dx86 -C ../../../.. headers_install
make[1]: Entering directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464=
ccf68e19bf7d303022d873141b5e1f7219'
  INSTALL ./usr/include
make[1]: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464c=
cf68e19bf7d303022d873141b5e1f7219'
TAP version 13
1..1
# selftests: gpio: gpio-mockup.sh
# 1.  Test dynamic allocation of gpio successful means insert gpiochip and
#     manipulate gpio pin successful
# GPIO gpio-mockup test with ranges: <-1,32>:=20
# -1,32     =20
# gpio<gpio-mockup> test failed
# Test gpiochip gpio-mockup: GPIO gpio-mockup test with ranges: <-1,32,-1,3=
2>:=20
# -1,32,-1,32=20
# gpio<gpio-mockup> test failed
# Test gpiochip gpio-mockup: GPIO gpio-mockup test with ranges: <-1,32,-1,3=
2,-1,32>:=20
# -1,32,-1,32,-1,32=20
# gpio<gpio-mockup> test failed
# Test gpiochip gpio-mockup: 3.  Error test: successful means insert gpioch=
ip failed
# 3.1 Test number of gpio overflow
# GPIO gpio-mockup test with ranges: <-1,32,-1,1024>:=20
# -1,32,-1,1024=20
# Test gpiochip gpio-mockup: Invalid test successful
# GPIO test PASS
ok 1 selftests: gpio: gpio-mockup.sh
make: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf6=
8e19bf7d303022d873141b5e1f7219/tools/testing/selftests/gpio'
ia64 test: not in Makefile
2020-04-09 08:19:11 make TARGETS=3Dia64
make --no-builtin-rules ARCH=3Dx86 -C ../../.. headers_install
make[1]: Entering directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464=
ccf68e19bf7d303022d873141b5e1f7219'
  INSTALL ./usr/include
make[1]: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464c=
cf68e19bf7d303022d873141b5e1f7219'
make[1]: Entering directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464=
ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/ia64'
Makefile:9: warning: overriding recipe for target 'clean'
=2E./lib.mk:123: warning: ignoring old recipe for target 'clean'
gcc     aliasing-test.c   -o aliasing-test
make[1]: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464c=
cf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/ia64'
2020-04-09 08:19:12 make run_tests -C ia64
make: Entering directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf=
68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/ia64'
Makefile:9: warning: overriding recipe for target 'clean'
=2E./lib.mk:123: warning: ignoring old recipe for target 'clean'
TAP version 13
1..1
# selftests: ia64: aliasing-test
# PASS: /dev/mem 0x0-0xa0000 is readable
# PASS: /dev/mem 0xa0000-0xc0000 is mappable
# PASS: /dev/mem 0xc0000-0x100000 is readable
# PASS: /dev/mem 0x0-0x100000 is mappable
# PASS: /sys/devices/pci0000:00/0000:00:02.0/rom read 65534 bytes
# PASS: /proc/bus/pci/00/00.0 0x0-0xa0000 not mappable
# PASS: /proc/bus/pci/00/01.0 0x0-0xa0000 not mappable
# PASS: /proc/bus/pci/00/02.0 0x0-0xa0000 not mappable
# PASS: /proc/bus/pci/00/14.0 0x0-0xa0000 not mappable
# PASS: /proc/bus/pci/00/14.2 0x0-0xa0000 not mappable
# PASS: /proc/bus/pci/00/16.0 0x0-0xa0000 not mappable
# PASS: /proc/bus/pci/00/17.0 0x0-0xa0000 not mappable
# PASS: /proc/bus/pci/00/1c.0 0x0-0xa0000 not mappable
# PASS: /proc/bus/pci/00/1f.0 0x0-0xa0000 not mappable
# PASS: /proc/bus/pci/00/1f.2 0x0-0xa0000 not mappable
# PASS: /proc/bus/pci/00/1f.3 0x0-0xa0000 not mappable
# PASS: /proc/bus/pci/00/1f.4 0x0-0xa0000 not mappable
# PASS: /proc/bus/pci/00/1f.6 0x0-0xa0000 not mappable
# PASS: /proc/bus/pci/02/00.0 0x0-0xa0000 not mappable
# PASS: /proc/bus/pci/00/00.0 0xa0000-0xc0000 not mappable
# PASS: /proc/bus/pci/00/01.0 0xa0000-0xc0000 not mappable
# PASS: /proc/bus/pci/00/02.0 0xa0000-0xc0000 not mappable
# PASS: /proc/bus/pci/00/14.0 0xa0000-0xc0000 not mappable
# PASS: /proc/bus/pci/00/14.2 0xa0000-0xc0000 not mappable
# PASS: /proc/bus/pci/00/16.0 0xa0000-0xc0000 not mappable
# PASS: /proc/bus/pci/00/17.0 0xa0000-0xc0000 not mappable
# PASS: /proc/bus/pci/00/1c.0 0xa0000-0xc0000 not mappable
# PASS: /proc/bus/pci/00/1f.0 0xa0000-0xc0000 not mappable
# PASS: /proc/bus/pci/00/1f.2 0xa0000-0xc0000 not mappable
# PASS: /proc/bus/pci/00/1f.3 0xa0000-0xc0000 not mappable
# PASS: /proc/bus/pci/00/1f.4 0xa0000-0xc0000 not mappable
# PASS: /proc/bus/pci/00/1f.6 0xa0000-0xc0000 not mappable
# PASS: /proc/bus/pci/02/00.0 0xa0000-0xc0000 not mappable
# PASS: /proc/bus/pci/00/00.0 0xc0000-0x100000 not mappable
# PASS: /proc/bus/pci/00/01.0 0xc0000-0x100000 not mappable
# PASS: /proc/bus/pci/00/02.0 0xc0000-0x100000 not mappable
# PASS: /proc/bus/pci/00/14.0 0xc0000-0x100000 not mappable
# PASS: /proc/bus/pci/00/14.2 0xc0000-0x100000 not mappable
# PASS: /proc/bus/pci/00/16.0 0xc0000-0x100000 not mappable
# PASS: /proc/bus/pci/00/17.0 0xc0000-0x100000 not mappable
# PASS: /proc/bus/pci/00/1c.0 0xc0000-0x100000 not mappable
# PASS: /proc/bus/pci/00/1f.0 0xc0000-0x100000 not mappable
# PASS: /proc/bus/pci/00/1f.2 0xc0000-0x100000 not mappable
# PASS: /proc/bus/pci/00/1f.3 0xc0000-0x100000 not mappable
# PASS: /proc/bus/pci/00/1f.4 0xc0000-0x100000 not mappable
# PASS: /proc/bus/pci/00/1f.6 0xc0000-0x100000 not mappable
# PASS: /proc/bus/pci/02/00.0 0xc0000-0x100000 not mappable
# PASS: /proc/bus/pci/00/00.0 0x0-0x100000 not mappable
# PASS: /proc/bus/pci/00/01.0 0x0-0x100000 not mappable
# PASS: /proc/bus/pci/00/02.0 0x0-0x100000 not mappable
# PASS: /proc/bus/pci/00/14.0 0x0-0x100000 not mappable
# PASS: /proc/bus/pci/00/14.2 0x0-0x100000 not mappable
# PASS: /proc/bus/pci/00/16.0 0x0-0x100000 not mappable
# PASS: /proc/bus/pci/00/17.0 0x0-0x100000 not mappable
# PASS: /proc/bus/pci/00/1c.0 0x0-0x100000 not mappable
# PASS: /proc/bus/pci/00/1f.0 0x0-0x100000 not mappable
# PASS: /proc/bus/pci/00/1f.2 0x0-0x100000 not mappable
# PASS: /proc/bus/pci/00/1f.3 0x0-0x100000 not mappable
# PASS: /proc/bus/pci/00/1f.4 0x0-0x100000 not mappable
# PASS: /proc/bus/pci/00/1f.6 0x0-0x100000 not mappable
# PASS: /proc/bus/pci/02/00.0 0x0-0x100000 not mappable
ok 1 selftests: ia64: aliasing-test
make: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf6=
8e19bf7d303022d873141b5e1f7219/tools/testing/selftests/ia64'
2020-04-09 08:19:13 make run_tests -C intel_pstate
make: Entering directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf=
68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/intel_pstate'
gcc  -Wall -D_GNU_SOURCE    msr.c /usr/src/perf_selftests-x86_64-rhel-7.6-d=
9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kselftest_h=
arness.h /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d8=
73141b5e1f7219/tools/testing/selftests/kselftest.h  -lm -o /usr/src/perf_se=
lftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/test=
ing/selftests/intel_pstate/msr
/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1=
f7219/tools/testing/selftests/kselftest_harness.h:53:0: warning: "_GNU_SOUR=
CE" redefined
 #define _GNU_SOURCE
=20
<command-line>:0:0: note: this is the location of the previous definition
gcc  -Wall -D_GNU_SOURCE    aperf.c /usr/src/perf_selftests-x86_64-rhel-7.6=
-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kselftest=
_harness.h /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022=
d873141b5e1f7219/tools/testing/selftests/kselftest.h  -lm -o /usr/src/perf_=
selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/te=
sting/selftests/intel_pstate/aperf
/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1=
f7219/tools/testing/selftests/kselftest_harness.h:53:0: warning: "_GNU_SOUR=
CE" redefined
 #define _GNU_SOURCE
=20
<command-line>:0:0: note: this is the location of the previous definition
TAP version 13
1..1
# selftests: intel_pstate: run.sh
# cpupower: error while loading shared libraries: libcpupower.so.0: cannot =
open shared object file: No such file or directory
# ./run.sh: line 90: / 1000: syntax error: operand expected (error token is=
 "/ 1000")
# cpupower: error while loading shared libraries: libcpupower.so.0: cannot =
open shared object file: No such file or directory
# ./run.sh: line 92: / 1000: syntax error: operand expected (error token is=
 "/ 1000")
# =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
# The marketing frequency of the cpu is 3400 MHz
# The maximum frequency of the cpu is  MHz
# The minimum frequency of the cpu is  MHz
# Target	      Actual	    Difference	  MSR(0x199)	max_perf_pct
ok 1 selftests: intel_pstate: run.sh
make: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf6=
8e19bf7d303022d873141b5e1f7219/tools/testing/selftests/intel_pstate'
2020-04-09 08:19:13 make run_tests -C ipc
make: Entering directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf=
68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/ipc'
gcc -DCONFIG_X86_64 -D__x86_64__ -I../../../../usr/include/    msgque.c /us=
r/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f72=
19/tools/testing/selftests/kselftest_harness.h /usr/src/perf_selftests-x86_=
64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftest=
s/kselftest.h  -o /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7=
d303022d873141b5e1f7219/tools/testing/selftests/ipc/msgque
TAP version 13
1..1
# selftests: ipc: msgque
# # Pass 0 Fail 0 Xfail 0 Xpass 0 Skip 0 Error 0
ok 1 selftests: ipc: msgque
make: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf6=
8e19bf7d303022d873141b5e1f7219/tools/testing/selftests/ipc'
ignored_by_lkp ir.ir_loopback_rcmm tests
2020-04-09 08:19:14 make run_tests -C ir
make: Entering directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf=
68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/ir'
gcc -Wall -O2 -I../../../include/uapi    ir_loopback.c /usr/src/perf_selfte=
sts-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/=
selftests/kselftest_harness.h /usr/src/perf_selftests-x86_64-rhel-7.6-d9d46=
4ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kselftest.h  -o=
 /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e=
1f7219/tools/testing/selftests/ir/ir_loopback
TAP version 13
1..1
# selftests: ir: ir_loopback.sh
# Sending IR on rc0 and receiving IR on rc0.
# Testing protocol rc-5 for decoder rc-5 (1/18)...
# Testing scancode:50a
# Testing scancode:1631
# Testing scancode:1725
# Testing scancode:628
# Testing scancode:1213
# Testing scancode:1d70
# Testing scancode:1a57
# Testing scancode:314
# Testing scancode:140
# Testing scancode:1528
# OK
# Testing protocol rc-5x-20 for decoder rc-5 (2/18)...
# Testing scancode:c0019
# Testing scancode:155a3d
# Testing scancode:77b3b
# Testing scancode:1b7337
# Testing scancode:b1b15
# Testing scancode:c5d26
# Testing scancode:1d1f36
# Testing scancode:22d29
# Testing scancode:1b2814
# Testing scancode:c2418
# OK
# Testing protocol rc-5-sz for decoder rc-5-sz (3/18)...
# Testing scancode:cf0
# Testing scancode:c3b
# Testing scancode:29df
# Testing scancode:2533
# Testing scancode:2877
# Testing scancode:2756
# Testing scancode:294a
# Testing scancode:209d
# Testing scancode:2d9
# Testing scancode:f95
# OK
# Testing protocol jvc for decoder jvc (4/18)...
# Testing scancode:819d
# Testing scancode:17e3
# Testing scancode:15c6
# Testing scancode:d942
# Testing scancode:9e8b
# Testing scancode:8859
# Testing scancode:9732
# Testing scancode:78e2
# Testing scancode:2bee
# Testing scancode:d8f2
# OK
# Testing protocol sony-12 for decoder sony (5/18)...
# Testing scancode:12000b
# Testing scancode:7
# Testing scancode:19006f
# Testing scancode:1a0046
# Testing scancode:1c007f
# Testing scancode:40005
# Testing scancode:6002d
# Testing scancode:190075
# Testing scancode:6002e
# Testing scancode:10041
# OK
# Testing protocol sony-15 for decoder sony (6/18)...
# Testing scancode:25000d
# Testing scancode:9d001e
# Testing scancode:72007c
# Testing scancode:72006c
# Testing scancode:5c0051
# Testing scancode:180074
# Testing scancode:ac0043
# Testing scancode:b2001b
# Testing scancode:4f0011
# Testing scancode:2d001c
# OK
# Testing protocol sony-20 for decoder sony (7/18)...
# Testing scancode:57630
# Testing scancode:8462e
# Testing scancode:17f7f
# Testing scancode:198c77
# Testing scancode:111f70
# Testing scancode:e1e0a
# Testing scancode:51450
# Testing scancode:6b622
# Testing scancode:15976c
# Testing scancode:19403e
# OK
# Testing protocol nec for decoder nec (8/18)...
# Testing scancode:8f95
# Testing scancode:a5f7
# Testing scancode:6d46
# Testing scancode:c304
# Testing scancode:afbe
# Testing scancode:8d45
# Testing scancode:9189
# Testing scancode:16eb
# Testing scancode:ccba
# Testing scancode:8d37
# OK
# Testing protocol nec-x for decoder nec (9/18)...
# Testing scancode:e9a62c
# Testing scancode:f430c8
# Testing scancode:cd55d6
# Testing scancode:5c11a8
# Testing scancode:664eb4
# Testing scancode:2a03a7
# Testing scancode:74a59c
# Testing scancode:12e3f7
# Testing scancode:dc9ac3
# Testing scancode:c46a2d
# OK
# Testing protocol nec-32 for decoder nec (10/18)...
# Testing scancode:2c404c13
# Testing scancode:6ae21173
# Testing scancode:104cb05b
# Testing scancode:1f01cc12
# Testing scancode:5fdb9dea
# Testing scancode:52bdcfcb
# Testing scancode:41afea9c
# Testing scancode:7960b2bb
# Testing scancode:38c4866e
# Testing scancode:61058209
# OK
# Testing protocol sanyo for decoder sanyo (11/18)...
# Testing scancode:19f379
# Testing scancode:f1603
# Testing scancode:d2800
# Testing scancode:1360bf
# Testing scancode:12d907
# Testing scancode:ed7be
# Testing scancode:8ee04
# Testing scancode:1b6a91
# Testing scancode:16eea9
# Testing scancode:17babf
# OK
# Testing protocol rc-6-0 for decoder rc-6 (12/18)...
# Testing scancode:f7c8
# Testing scancode:94d5
# Testing scancode:eb87
# Testing scancode:4d9e
# Testing scancode:a67e
# Testing scancode:3a3b
# Testing scancode:5146
# Testing scancode:4c1a
# Testing scancode:1e33
# Testing scancode:ec09
# OK
# Testing protocol rc-6-6a-20 for decoder rc-6 (13/18)...
# Testing scancode:5b648
# Testing scancode:56a46
# Testing scancode:fd7c
# Testing scancode:266a3
# Testing scancode:73659
# Testing scancode:c9b67
# Testing scancode:366f
# Testing scancode:720f5
# Testing scancode:d4e22
# Testing scancode:4bcdd
# OK
# Testing protocol rc-6-6a-24 for decoder rc-6 (14/18)...
# Testing scancode:dca2fe
# Testing scancode:77419b
# Testing scancode:33d2e0
# Testing scancode:49caff
# Testing scancode:2aa25b
# Testing scancode:66abe7
# Testing scancode:d8a2bd
# Testing scancode:d3905f
# Testing scancode:421678
# Testing scancode:ef9167
# OK
# Testing protocol rc-6-6a-32 for decoder rc-6 (15/18)...
# Testing scancode:84b4b1e
# Testing scancode:744d0e41
# Testing scancode:1af0263c
# Testing scancode:53b736a5
# Testing scancode:41255bdf
# Testing scancode:174cccba
# Testing scancode:118970e1
# Testing scancode:2a27ad25
# Testing scancode:651e18d5
# Testing scancode:586e8f14
# OK
# Testing protocol rc-6-mce for decoder rc-6 (16/18)...
# Testing scancode:800f192e
# Testing scancode:800f4f1d
# Testing scancode:800f795a
# Testing scancode:800f16ab
# Testing scancode:800f35c0
# Testing scancode:800f2fb3
# Testing scancode:800f3212
# Testing scancode:800f6c2f
# Testing scancode:800f50a9
# Testing scancode:800f0034
# OK
# Testing protocol sharp for decoder sharp (17/18)...
# Testing scancode:90c
# Testing scancode:13a7
# Testing scancode:1cf
# Testing scancode:1bec
# Testing scancode:1ea6
# Testing scancode:42a
# Testing scancode:7d4
# Testing scancode:164
# Testing scancode:148a
# Testing scancode:1e4c
# OK
# Testing protocol imon for decoder imon (18/18)...
# Testing scancode:3580f2cb
# Testing scancode:21223fa8
# Testing scancode:71c4cc8d
# Testing scancode:50711907
# Testing scancode:74d9764e
# Testing scancode:32ea286d
# Testing scancode:67bde5c2
# Testing scancode:662e72f
# Testing scancode:5d11d592
# Testing scancode:4cdbfe97
# OK
# # Planned tests !=3D run tests (0 !=3D 180)
# # Pass 180 Fail 0 Xfail 0 Xpass 0 Skip 0 Error 0
ok 1 selftests: ir: ir_loopback.sh
make: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf6=
8e19bf7d303022d873141b5e1f7219/tools/testing/selftests/ir'
2020-04-09 08:19:24 make run_tests -C kcmp
make: Entering directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf=
68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kcmp'
gcc -I../../../../usr/include/    kcmp_test.c /usr/src/perf_selftests-x86_6=
4-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests=
/kselftest_harness.h /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19=
bf7d303022d873141b5e1f7219/tools/testing/selftests/kselftest.h  -o /usr/src=
/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/to=
ols/testing/selftests/kcmp/kcmp_test
TAP version 13
1..1
# selftests: kcmp: kcmp_test
# pid1:  23090 pid2:  23091 FD:  1 FILES:  2 VM:  1 FS:  1 SIGHAND:  2 IO: =
 0 SYSVSEM:  0 INV: -1
# PASS: 0 returned as expected
# PASS: 0 returned as expected
# PASS: 0 returned as expected
# # Planned tests !=3D run tests (0 !=3D 3)
# # Pass 3 Fail 0 Xfail 0 Xpass 0 Skip 0 Error 0
# # Planned tests !=3D run tests (0 !=3D 3)
# # Pass 3 Fail 0 Xfail 0 Xpass 0 Skip 0 Error 0
# # Pass 0 Fail 0 Xfail 0 Xpass 0 Skip 0 Error 0
ok 1 selftests: kcmp: kcmp_test
make: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf6=
8e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kcmp'
2020-04-09 08:19:24 make run_tests -C kexec
make: Entering directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf=
68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kexec'
TAP version 13
1..2
# selftests: kexec: test_kexec_load.sh
# [INFO] kexec_load is enabled
# [INFO] IMA enabled
# [INFO] efivars is not mounted on /sys/firmware/efi/efivars
# efi_vars is not enabled
#=20
not ok 1 selftests: kexec: test_kexec_load.sh # SKIP
# selftests: kexec: test_kexec_file_load.sh
# [INFO] kexec_file_load is enabled
# [INFO] IMA enabled
# [INFO] efivars is not mounted on /sys/firmware/efi/efivars
# efi_vars is not enabled
#=20
not ok 2 selftests: kexec: test_kexec_file_load.sh # SKIP
make: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf6=
8e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kexec'
kmod test: not in Makefile
2020-04-09 08:19:24 make TARGETS=3Dkmod
make --no-builtin-rules ARCH=3Dx86 -C ../../.. headers_install
make[1]: Entering directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464=
ccf68e19bf7d303022d873141b5e1f7219'
  INSTALL ./usr/include
make[1]: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464c=
cf68e19bf7d303022d873141b5e1f7219'
make[1]: Entering directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464=
ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kmod'
make[1]: Nothing to be done for 'all'.
make[1]: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464c=
cf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kmod'
2020-04-09 08:19:25 make run_tests -C kmod
make: Entering directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf=
68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kmod'
TAP version 13
1..1
# selftests: kmod: kmod.sh
# Thu Apr  9 08:19:25 CST 2020
# Running test: kmod_test_0001 - run #0
# kmod_test_0001_driver: OK! - loading kmod test
# kmod_test_0001_driver: OK! - Return value: 256 (MODULE_NOT_FOUND), expect=
ed MODULE_NOT_FOUND
# kmod_test_0001_fs: OK! - loading kmod test
# kmod_test_0001_fs: OK! - Return value: -22 (-EINVAL), expected -EINVAL
# Thu Apr  9 08:19:25 CST 2020
# Running test: kmod_test_0001 - run #1
# kmod_test_0001_driver: OK! - loading kmod test
# kmod_test_0001_driver: OK! - Return value: 256 (MODULE_NOT_FOUND), expect=
ed MODULE_NOT_FOUND
# kmod_test_0001_fs: OK! - loading kmod test
# kmod_test_0001_fs: OK! - Return value: -22 (-EINVAL), expected -EINVAL
# Thu Apr  9 08:19:26 CST 2020
# Running test: kmod_test_0001 - run #2
# kmod_test_0001_driver: OK! - loading kmod test
# kmod_test_0001_driver: OK! - Return value: 256 (MODULE_NOT_FOUND), expect=
ed MODULE_NOT_FOUND
# kmod_test_0001_fs: OK! - loading kmod test
# kmod_test_0001_fs: OK! - Return value: -22 (-EINVAL), expected -EINVAL
# Thu Apr  9 08:19:26 CST 2020
# Running test: kmod_test_0002 - run #0
# kmod_test_0002_driver: OK! - loading kmod test
# kmod_test_0002_driver: OK! - Return value: 256 (MODULE_NOT_FOUND), expect=
ed MODULE_NOT_FOUND
# kmod_test_0002_fs: OK! - loading kmod test
# kmod_test_0002_fs: OK! - Return value: -22 (-EINVAL), expected -EINVAL
# Thu Apr  9 08:19:26 CST 2020
# Running test: kmod_test_0002 - run #1
# kmod_test_0002_driver: OK! - loading kmod test
# kmod_test_0002_driver: OK! - Return value: 256 (MODULE_NOT_FOUND), expect=
ed MODULE_NOT_FOUND
# kmod_test_0002_fs: OK! - loading kmod test
# kmod_test_0002_fs: OK! - Return value: -22 (-EINVAL), expected -EINVAL
# Thu Apr  9 08:19:27 CST 2020
# Running test: kmod_test_0002 - run #2
# kmod_test_0002_driver: OK! - loading kmod test
# kmod_test_0002_driver: OK! - Return value: 256 (MODULE_NOT_FOUND), expect=
ed MODULE_NOT_FOUND
# kmod_test_0002_fs: OK! - loading kmod test
# kmod_test_0002_fs: OK! - Return value: -22 (-EINVAL), expected -EINVAL
# Thu Apr  9 08:19:27 CST 2020
# Running test: kmod_test_0003 - run #0
# kmod_test_0003: OK! - loading kmod test
# kmod_test_0003: OK! - Return value: 0 (SUCCESS), expected SUCCESS
# Thu Apr  9 08:19:27 CST 2020
# Running test: kmod_test_0004 - run #0
# kmod_test_0004: OK! - loading kmod test
# kmod_test_0004: OK! - Return value: 0 (SUCCESS), expected SUCCESS
# Thu Apr  9 08:19:28 CST 2020
# Running test: kmod_test_0005 - run #0
# kmod_test_0005: OK! - loading kmod test
# kmod_test_0005: OK! - Return value: 0 (SUCCESS), expected SUCCESS
# Thu Apr  9 08:19:28 CST 2020
# Running test: kmod_test_0005 - run #1
# kmod_test_0005: OK! - loading kmod test
# kmod_test_0005: OK! - Return value: 0 (SUCCESS), expected SUCCESS
# Thu Apr  9 08:19:29 CST 2020
# Running test: kmod_test_0005 - run #2
# kmod_test_0005: OK! - loading kmod test
# kmod_test_0005: OK! - Return value: 0 (SUCCESS), expected SUCCESS
# Thu Apr  9 08:19:29 CST 2020
# Running test: kmod_test_0005 - run #3
# kmod_test_0005: OK! - loading kmod test
# kmod_test_0005: OK! - Return value: 0 (SUCCESS), expected SUCCESS
# Thu Apr  9 08:19:29 CST 2020
# Running test: kmod_test_0005 - run #4
# kmod_test_0005: OK! - loading kmod test
# kmod_test_0005: OK! - Return value: 0 (SUCCESS), expected SUCCESS
# Thu Apr  9 08:19:30 CST 2020
# Running test: kmod_test_0005 - run #5
# kmod_test_0005: OK! - loading kmod test
# kmod_test_0005: OK! - Return value: 0 (SUCCESS), expected SUCCESS
# Thu Apr  9 08:19:30 CST 2020
# Running test: kmod_test_0005 - run #6
# kmod_test_0005: OK! - loading kmod test
# kmod_test_0005: OK! - Return value: 0 (SUCCESS), expected SUCCESS
# Thu Apr  9 08:19:31 CST 2020
# Running test: kmod_test_0005 - run #7
# kmod_test_0005: OK! - loading kmod test
# kmod_test_0005: OK! - Return value: 0 (SUCCESS), expected SUCCESS
# Thu Apr  9 08:19:31 CST 2020
# Running test: kmod_test_0005 - run #8
# kmod_test_0005: OK! - loading kmod test
# kmod_test_0005: OK! - Return value: 0 (SUCCESS), expected SUCCESS
# Thu Apr  9 08:19:31 CST 2020
# Running test: kmod_test_0005 - run #9
# kmod_test_0005: OK! - loading kmod test
# kmod_test_0005: OK! - Return value: 0 (SUCCESS), expected SUCCESS
# Thu Apr  9 08:19:32 CST 2020
# Running test: kmod_test_0006 - run #0
# kmod_test_0006: OK! - loading kmod test
# kmod_test_0006: OK! - Return value: 0 (SUCCESS), expected SUCCESS
# Thu Apr  9 08:19:33 CST 2020
# Running test: kmod_test_0006 - run #1
# kmod_test_0006: OK! - loading kmod test
# kmod_test_0006: OK! - Return value: 0 (SUCCESS), expected SUCCESS
# Thu Apr  9 08:19:34 CST 2020
# Running test: kmod_test_0006 - run #2
# kmod_test_0006: OK! - loading kmod test
# kmod_test_0006: OK! - Return value: 0 (SUCCESS), expected SUCCESS
# Thu Apr  9 08:19:35 CST 2020
# Running test: kmod_test_0006 - run #3
# kmod_test_0006: OK! - loading kmod test
# kmod_test_0006: OK! - Return value: 0 (SUCCESS), expected SUCCESS
# Thu Apr  9 08:19:36 CST 2020
# Running test: kmod_test_0006 - run #4
# kmod_test_0006: OK! - loading kmod test
# kmod_test_0006: OK! - Return value: 0 (SUCCESS), expected SUCCESS
# Thu Apr  9 08:19:37 CST 2020
# Running test: kmod_test_0006 - run #5
# kmod_test_0006: OK! - loading kmod test
# kmod_test_0006: OK! - Return value: 0 (SUCCESS), expected SUCCESS
# Thu Apr  9 08:19:38 CST 2020
# Running test: kmod_test_0006 - run #6
# kmod_test_0006: OK! - loading kmod test
# kmod_test_0006: OK! - Return value: 0 (SUCCESS), expected SUCCESS
# Thu Apr  9 08:19:40 CST 2020
# Running test: kmod_test_0006 - run #7
# kmod_test_0006: OK! - loading kmod test
# kmod_test_0006: OK! - Return value: 0 (SUCCESS), expected SUCCESS
# Thu Apr  9 08:19:42 CST 2020
# Running test: kmod_test_0006 - run #8
# kmod_test_0006: OK! - loading kmod test
# kmod_test_0006: OK! - Return value: 0 (SUCCESS), expected SUCCESS
# Thu Apr  9 08:19:43 CST 2020
# Running test: kmod_test_0006 - run #9
# kmod_test_0006: OK! - loading kmod test
# kmod_test_0006: OK! - Return value: 0 (SUCCESS), expected SUCCESS
# Thu Apr  9 08:19:43 CST 2020
# Running test: kmod_test_0007 - run #0
# kmod_test_0005: OK! - loading kmod test
# kmod_test_0005: OK! - Return value: 0 (SUCCESS), expected SUCCESS
# kmod_test_0006: OK! - loading kmod test
# kmod_test_0006: OK! - Return value: 0 (SUCCESS), expected SUCCESS
# Thu Apr  9 08:19:45 CST 2020
# Running test: kmod_test_0007 - run #1
# kmod_test_0005: OK! - loading kmod test
# kmod_test_0005: OK! - Return value: 0 (SUCCESS), expected SUCCESS
# kmod_test_0006: OK! - loading kmod test
# kmod_test_0006: OK! - Return value: 0 (SUCCESS), expected SUCCESS
# Thu Apr  9 08:19:46 CST 2020
# Running test: kmod_test_0007 - run #2
# kmod_test_0005: OK! - loading kmod test
# kmod_test_0005: OK! - Return value: 0 (SUCCESS), expected SUCCESS
# kmod_test_0006: OK! - loading kmod test
# kmod_test_0006: OK! - Return value: 0 (SUCCESS), expected SUCCESS
# Thu Apr  9 08:19:48 CST 2020
# Running test: kmod_test_0007 - run #3
# kmod_test_0005: OK! - loading kmod test
# kmod_test_0005: OK! - Return value: 0 (SUCCESS), expected SUCCESS
# kmod_test_0006: OK! - loading kmod test
# kmod_test_0006: OK! - Return value: 0 (SUCCESS), expected SUCCESS
# Thu Apr  9 08:19:50 CST 2020
# Running test: kmod_test_0007 - run #4
# kmod_test_0005: OK! - loading kmod test
# kmod_test_0005: OK! - Return value: 0 (SUCCESS), expected SUCCESS
# kmod_test_0006: OK! - loading kmod test
# kmod_test_0006: OK! - Return value: 0 (SUCCESS), expected SUCCESS
# ./kmod.sh: line 529: [[: 1 0002:3:1 0003:1:1 0004:1:1 0005:10:1 0006:10:1=
 0007:5:1 0008:150:1 0009:150:1: syntax error in expression (error token is=
 "0002:3:1 0003:1:1 0004:1:1 0005:10:1 0006:10:1 0007:5:1 0008:150:1 0009:1=
50:1")
# ./kmod.sh: line 529: [[: 1 0002:3:1 0003:1:1 0004:1:1 0005:10:1 0006:10:1=
 0007:5:1 0008:150:1 0009:150:1: syntax error in expression (error token is=
 "0002:3:1 0003:1:1 0004:1:1 0005:10:1 0006:10:1 0007:5:1 0008:150:1 0009:1=
50:1")
# Test completed
ok 1 selftests: kmod: kmod.sh
make: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf6=
8e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kmod'
2020-04-09 08:19:52 make run_tests -C kvm
make: Entering directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf=
68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kvm'
make --no-builtin-rules ARCH=3Dx86 -C ../../../.. headers_install
make[1]: Entering directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464=
ccf68e19bf7d303022d873141b5e1f7219'
  INSTALL ./usr/include
make[1]: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464c=
cf68e19bf7d303022d873141b5e1f7219'
gcc -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=3Dgnu99 -fno-stac=
k-protector -fno-PIE -I../../../../tools/include -I../../../../tools/arch/x=
86/include -I../../../../usr/include/ -Iinclude -Ilib -Iinclude/x86_64 -I..=
   -c lib/assert.c -o /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e1=
9bf7d303022d873141b5e1f7219/tools/testing/selftests/kvm/lib/assert.o
gcc -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=3Dgnu99 -fno-stac=
k-protector -fno-PIE -I../../../../tools/include -I../../../../tools/arch/x=
86/include -I../../../../usr/include/ -Iinclude -Ilib -Iinclude/x86_64 -I..=
   -c lib/elf.c -o /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf=
7d303022d873141b5e1f7219/tools/testing/selftests/kvm/lib/elf.o
gcc -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=3Dgnu99 -fno-stac=
k-protector -fno-PIE -I../../../../tools/include -I../../../../tools/arch/x=
86/include -I../../../../usr/include/ -Iinclude -Ilib -Iinclude/x86_64 -I..=
   -c lib/io.c -o /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7=
d303022d873141b5e1f7219/tools/testing/selftests/kvm/lib/io.o
gcc -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=3Dgnu99 -fno-stac=
k-protector -fno-PIE -I../../../../tools/include -I../../../../tools/arch/x=
86/include -I../../../../usr/include/ -Iinclude -Ilib -Iinclude/x86_64 -I..=
   -c lib/kvm_util.c -o /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68=
e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kvm/lib/kvm_util.o
gcc -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=3Dgnu99 -fno-stac=
k-protector -fno-PIE -I../../../../tools/include -I../../../../tools/arch/x=
86/include -I../../../../usr/include/ -Iinclude -Ilib -Iinclude/x86_64 -I..=
   -c lib/sparsebit.c -o /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf6=
8e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kvm/lib/sparsebit.o
gcc -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=3Dgnu99 -fno-stac=
k-protector -fno-PIE -I../../../../tools/include -I../../../../tools/arch/x=
86/include -I../../../../usr/include/ -Iinclude -Ilib/x86_64 -Iinclude/x86_=
64 -I..   -c lib/x86_64/processor.c -o /usr/src/perf_selftests-x86_64-rhel-=
7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kvm/li=
b/x86_64/processor.o
gcc -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=3Dgnu99 -fno-stac=
k-protector -fno-PIE -I../../../../tools/include -I../../../../tools/arch/x=
86/include -I../../../../usr/include/ -Iinclude -Ilib/x86_64 -Iinclude/x86_=
64 -I..   -c lib/x86_64/vmx.c -o /usr/src/perf_selftests-x86_64-rhel-7.6-d9=
d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kvm/lib/x86_=
64/vmx.o
gcc -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=3Dgnu99 -fno-stac=
k-protector -fno-PIE -I../../../../tools/include -I../../../../tools/arch/x=
86/include -I../../../../usr/include/ -Iinclude -Ilib/x86_64 -Iinclude/x86_=
64 -I..   -c lib/x86_64/ucall.c -o /usr/src/perf_selftests-x86_64-rhel-7.6-=
d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kvm/lib/x8=
6_64/ucall.o
ar crs /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873=
141b5e1f7219/tools/testing/selftests/kvm/libkvm.a /usr/src/perf_selftests-x=
86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selft=
ests/kvm/lib/assert.o /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e1=
9bf7d303022d873141b5e1f7219/tools/testing/selftests/kvm/lib/elf.o /usr/src/=
perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/too=
ls/testing/selftests/kvm/lib/io.o /usr/src/perf_selftests-x86_64-rhel-7.6-d=
9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kvm/lib/kvm=
_util.o /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d87=
3141b5e1f7219/tools/testing/selftests/kvm/lib/sparsebit.o /usr/src/perf_sel=
ftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testi=
ng/selftests/kvm/lib/x86_64/processor.o /usr/src/perf_selftests-x86_64-rhel=
-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kvm/l=
ib/x86_64/vmx.o /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d3=
03022d873141b5e1f7219/tools/testing/selftests/kvm/lib/x86_64/ucall.o
gcc -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=3Dgnu99 -fno-stac=
k-protector -fno-PIE -I../../../../tools/include -I../../../../tools/arch/x=
86/include -I../../../../usr/include/ -Iinclude -Ix86_64 -Iinclude/x86_64 -=
I..  -pthread  -no-pie   x86_64/cr4_cpuid_sync_test.c /usr/src/perf_selftes=
ts-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/s=
elftests/kselftest_harness.h /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464=
ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kselftest.h /usr=
/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f721=
9/tools/testing/selftests/kvm/libkvm.a  -o /usr/src/perf_selftests-x86_64-r=
hel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kv=
m/x86_64/cr4_cpuid_sync_test
gcc -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=3Dgnu99 -fno-stac=
k-protector -fno-PIE -I../../../../tools/include -I../../../../tools/arch/x=
86/include -I../../../../usr/include/ -Iinclude -Ix86_64 -Iinclude/x86_64 -=
I..  -pthread  -no-pie   x86_64/evmcs_test.c /usr/src/perf_selftests-x86_64=
-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/=
kselftest_harness.h /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19b=
f7d303022d873141b5e1f7219/tools/testing/selftests/kselftest.h /usr/src/perf=
_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/t=
esting/selftests/kvm/libkvm.a  -o /usr/src/perf_selftests-x86_64-rhel-7.6-d=
9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kvm/x86_64/=
evmcs_test
gcc -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=3Dgnu99 -fno-stac=
k-protector -fno-PIE -I../../../../tools/include -I../../../../tools/arch/x=
86/include -I../../../../usr/include/ -Iinclude -Ix86_64 -Iinclude/x86_64 -=
I..  -pthread  -no-pie   x86_64/hyperv_cpuid.c /usr/src/perf_selftests-x86_=
64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftest=
s/kselftest_harness.h /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e1=
9bf7d303022d873141b5e1f7219/tools/testing/selftests/kselftest.h /usr/src/pe=
rf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools=
/testing/selftests/kvm/libkvm.a  -o /usr/src/perf_selftests-x86_64-rhel-7.6=
-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kvm/x86_6=
4/hyperv_cpuid
gcc -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=3Dgnu99 -fno-stac=
k-protector -fno-PIE -I../../../../tools/include -I../../../../tools/arch/x=
86/include -I../../../../usr/include/ -Iinclude -Ix86_64 -Iinclude/x86_64 -=
I..  -pthread  -no-pie   x86_64/mmio_warning_test.c /usr/src/perf_selftests=
-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/sel=
ftests/kselftest_harness.h /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464cc=
f68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kselftest.h /usr/s=
rc/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/=
tools/testing/selftests/kvm/libkvm.a  -o /usr/src/perf_selftests-x86_64-rhe=
l-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kvm/=
x86_64/mmio_warning_test
gcc -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=3Dgnu99 -fno-stac=
k-protector -fno-PIE -I../../../../tools/include -I../../../../tools/arch/x=
86/include -I../../../../usr/include/ -Iinclude -Ix86_64 -Iinclude/x86_64 -=
I..  -pthread  -no-pie   x86_64/platform_info_test.c /usr/src/perf_selftest=
s-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/se=
lftests/kselftest_harness.h /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464c=
cf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kselftest.h /usr/=
src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219=
/tools/testing/selftests/kvm/libkvm.a  -o /usr/src/perf_selftests-x86_64-rh=
el-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kvm=
/x86_64/platform_info_test
gcc -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=3Dgnu99 -fno-stac=
k-protector -fno-PIE -I../../../../tools/include -I../../../../tools/arch/x=
86/include -I../../../../usr/include/ -Iinclude -Ix86_64 -Iinclude/x86_64 -=
I..  -pthread  -no-pie   x86_64/set_sregs_test.c /usr/src/perf_selftests-x8=
6_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selfte=
sts/kselftest_harness.h /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68=
e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kselftest.h /usr/src/=
perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/too=
ls/testing/selftests/kvm/libkvm.a  -o /usr/src/perf_selftests-x86_64-rhel-7=
=2E6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kvm/x=
86_64/set_sregs_test
gcc -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=3Dgnu99 -fno-stac=
k-protector -fno-PIE -I../../../../tools/include -I../../../../tools/arch/x=
86/include -I../../../../usr/include/ -Iinclude -Ix86_64 -Iinclude/x86_64 -=
I..  -pthread  -no-pie   x86_64/smm_test.c /usr/src/perf_selftests-x86_64-r=
hel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/ks=
elftest_harness.h /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7=
d303022d873141b5e1f7219/tools/testing/selftests/kselftest.h /usr/src/perf_s=
elftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/tes=
ting/selftests/kvm/libkvm.a  -o /usr/src/perf_selftests-x86_64-rhel-7.6-d9d=
464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kvm/x86_64/sm=
m_test
gcc -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=3Dgnu99 -fno-stac=
k-protector -fno-PIE -I../../../../tools/include -I../../../../tools/arch/x=
86/include -I../../../../usr/include/ -Iinclude -Ix86_64 -Iinclude/x86_64 -=
I..  -pthread  -no-pie   x86_64/state_test.c /usr/src/perf_selftests-x86_64=
-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/=
kselftest_harness.h /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19b=
f7d303022d873141b5e1f7219/tools/testing/selftests/kselftest.h /usr/src/perf=
_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/t=
esting/selftests/kvm/libkvm.a  -o /usr/src/perf_selftests-x86_64-rhel-7.6-d=
9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kvm/x86_64/=
state_test
gcc -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=3Dgnu99 -fno-stac=
k-protector -fno-PIE -I../../../../tools/include -I../../../../tools/arch/x=
86/include -I../../../../usr/include/ -Iinclude -Ix86_64 -Iinclude/x86_64 -=
I..  -pthread  -no-pie   x86_64/sync_regs_test.c /usr/src/perf_selftests-x8=
6_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selfte=
sts/kselftest_harness.h /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68=
e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kselftest.h /usr/src/=
perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/too=
ls/testing/selftests/kvm/libkvm.a  -o /usr/src/perf_selftests-x86_64-rhel-7=
=2E6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kvm/x=
86_64/sync_regs_test
gcc -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=3Dgnu99 -fno-stac=
k-protector -fno-PIE -I../../../../tools/include -I../../../../tools/arch/x=
86/include -I../../../../usr/include/ -Iinclude -Ix86_64 -Iinclude/x86_64 -=
I..  -pthread  -no-pie   x86_64/vmx_close_while_nested_test.c /usr/src/perf=
_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/t=
esting/selftests/kselftest_harness.h /usr/src/perf_selftests-x86_64-rhel-7.=
6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kselftes=
t.h /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141=
b5e1f7219/tools/testing/selftests/kvm/libkvm.a  -o /usr/src/perf_selftests-=
x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/self=
tests/kvm/x86_64/vmx_close_while_nested_test
gcc -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=3Dgnu99 -fno-stac=
k-protector -fno-PIE -I../../../../tools/include -I../../../../tools/arch/x=
86/include -I../../../../usr/include/ -Iinclude -Ix86_64 -Iinclude/x86_64 -=
I..  -pthread  -no-pie   x86_64/vmx_dirty_log_test.c /usr/src/perf_selftest=
s-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/se=
lftests/kselftest_harness.h /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464c=
cf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kselftest.h /usr/=
src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219=
/tools/testing/selftests/kvm/libkvm.a  -o /usr/src/perf_selftests-x86_64-rh=
el-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kvm=
/x86_64/vmx_dirty_log_test
gcc -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=3Dgnu99 -fno-stac=
k-protector -fno-PIE -I../../../../tools/include -I../../../../tools/arch/x=
86/include -I../../../../usr/include/ -Iinclude -Ix86_64 -Iinclude/x86_64 -=
I..  -pthread  -no-pie   x86_64/vmx_set_nested_state_test.c /usr/src/perf_s=
elftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/tes=
ting/selftests/kselftest_harness.h /usr/src/perf_selftests-x86_64-rhel-7.6-=
d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kselftest.=
h /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5=
e1f7219/tools/testing/selftests/kvm/libkvm.a  -o /usr/src/perf_selftests-x8=
6_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selfte=
sts/kvm/x86_64/vmx_set_nested_state_test
gcc -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=3Dgnu99 -fno-stac=
k-protector -fno-PIE -I../../../../tools/include -I../../../../tools/arch/x=
86/include -I../../../../usr/include/ -Iinclude -Ix86_64 -Iinclude/x86_64 -=
I..  -pthread  -no-pie   x86_64/vmx_tsc_adjust_test.c /usr/src/perf_selftes=
ts-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/s=
elftests/kselftest_harness.h /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464=
ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kselftest.h /usr=
/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f721=
9/tools/testing/selftests/kvm/libkvm.a  -o /usr/src/perf_selftests-x86_64-r=
hel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kv=
m/x86_64/vmx_tsc_adjust_test
gcc -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=3Dgnu99 -fno-stac=
k-protector -fno-PIE -I../../../../tools/include -I../../../../tools/arch/x=
86/include -I../../../../usr/include/ -Iinclude -Ix86_64 -Iinclude/x86_64 -=
I..  -pthread  -no-pie   x86_64/xss_msr_test.c /usr/src/perf_selftests-x86_=
64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftest=
s/kselftest_harness.h /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e1=
9bf7d303022d873141b5e1f7219/tools/testing/selftests/kselftest.h /usr/src/pe=
rf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools=
/testing/selftests/kvm/libkvm.a  -o /usr/src/perf_selftests-x86_64-rhel-7.6=
-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kvm/x86_6=
4/xss_msr_test
gcc -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=3Dgnu99 -fno-stac=
k-protector -fno-PIE -I../../../../tools/include -I../../../../tools/arch/x=
86/include -I../../../../usr/include/ -Iinclude -I. -Iinclude/x86_64 -I..  =
-pthread  -no-pie   clear_dirty_log_test.c /usr/src/perf_selftests-x86_64-r=
hel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/ks=
elftest_harness.h /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7=
d303022d873141b5e1f7219/tools/testing/selftests/kselftest.h /usr/src/perf_s=
elftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/tes=
ting/selftests/kvm/libkvm.a  -o /usr/src/perf_selftests-x86_64-rhel-7.6-d9d=
464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kvm/clear_dir=
ty_log_test
gcc -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=3Dgnu99 -fno-stac=
k-protector -fno-PIE -I../../../../tools/include -I../../../../tools/arch/x=
86/include -I../../../../usr/include/ -Iinclude -I. -Iinclude/x86_64 -I..  =
-pthread  -no-pie   dirty_log_test.c /usr/src/perf_selftests-x86_64-rhel-7.=
6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kselftes=
t_harness.h /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d30302=
2d873141b5e1f7219/tools/testing/selftests/kselftest.h /usr/src/perf_selftes=
ts-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/s=
elftests/kvm/libkvm.a  -o /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf=
68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kvm/dirty_log_test
gcc -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=3Dgnu99 -fno-stac=
k-protector -fno-PIE -I../../../../tools/include -I../../../../tools/arch/x=
86/include -I../../../../usr/include/ -Iinclude -I. -Iinclude/x86_64 -I..  =
-pthread  -no-pie   kvm_create_max_vcpus.c /usr/src/perf_selftests-x86_64-r=
hel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/ks=
elftest_harness.h /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7=
d303022d873141b5e1f7219/tools/testing/selftests/kselftest.h /usr/src/perf_s=
elftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/tes=
ting/selftests/kvm/libkvm.a  -o /usr/src/perf_selftests-x86_64-rhel-7.6-d9d=
464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kvm/kvm_creat=
e_max_vcpus
TAP version 13
1..17
# selftests: kvm: cr4_cpuid_sync_test
# Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
# Guest physical address width detected: 39
ok 1 selftests: kvm: cr4_cpuid_sync_test
# selftests: kvm: evmcs_test
# Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
# Guest physical address width detected: 39
ok 2 selftests: kvm: evmcs_test
# selftests: kvm: hyperv_cpuid
# Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
# Guest physical address width detected: 39
ok 3 selftests: kvm: hyperv_cpuid
# selftests: kvm: mmio_warning_test
# ret1=3D0 exit_reason=3D17 suberror=3D1
# ret1=3D0 exit_reason=3D8 suberror=3D65530
# ret1=3D0 exit_reason=3D17 suberror=3D1
# ret1=3D0 exit_reason=3D8 suberror=3D65530
# ret1=3D0 exit_reason=3D17 suberror=3D1
# ret1=3D0 exit_reason=3D8 suberror=3D65530
# ret1=3D0 exit_reason=3D17 suberror=3D1
# ret1=3D0 exit_reason=3D8 suberror=3D65530
# ret1=3D0 exit_reason=3D17 suberror=3D1
# ret1=3D0 exit_reason=3D8 suberror=3D65530
# ret1=3D0 exit_reason=3D17 suberror=3D1
# ret1=3D0 exit_reason=3D8 suberror=3D65530
# ret1=3D0 exit_reason=3D17 suberror=3D1
# ret1=3D0 exit_reason=3D8 suberror=3D65530
# ret1=3D0 exit_reason=3D17 suberror=3D1
# ret1=3D0 exit_reason=3D8 suberror=3D65530
# ret1=3D0 exit_reason=3D17 suberror=3D1
# ret1=3D0 exit_reason=3D8 suberror=3D65530
# ret1=3D0 exit_reason=3D17 suberror=3D1
# ret1=3D0 exit_reason=3D8 suberror=3D65530
ok 4 selftests: kvm: mmio_warning_test
# selftests: kvm: platform_info_test
# Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
# Guest physical address width detected: 39
ok 5 selftests: kvm: platform_info_test
# selftests: kvm: set_sregs_test
# Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
# Guest physical address width detected: 39
ok 6 selftests: kvm: set_sregs_test
# selftests: kvm: smm_test
# Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
# Guest physical address width detected: 39
ok 7 selftests: kvm: smm_test
# selftests: kvm: state_test
# Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
# Guest physical address width detected: 39
ok 8 selftests: kvm: state_test
# selftests: kvm: sync_regs_test
# Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
# Guest physical address width detected: 39
ok 9 selftests: kvm: sync_regs_test
# selftests: kvm: vmx_close_while_nested_test
# Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
# Guest physical address width detected: 39
ok 10 selftests: kvm: vmx_close_while_nested_test
# selftests: kvm: vmx_dirty_log_test
# Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
# Guest physical address width detected: 39
ok 11 selftests: kvm: vmx_dirty_log_test
# selftests: kvm: vmx_set_nested_state_test
# Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
# Guest physical address width detected: 39
ok 12 selftests: kvm: vmx_set_nested_state_test
# selftests: kvm: vmx_tsc_adjust_test
# Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
# Guest physical address width detected: 39
# IA32_TSC_ADJUST is -4294971104 (-1 * TSC_ADJUST_VALUE + -3808).
# IA32_TSC_ADJUST is -4294971104 (-1 * TSC_ADJUST_VALUE + -3808).
# IA32_TSC_ADJUST is -8589949798 (-2 * TSC_ADJUST_VALUE + -15206).
# IA32_TSC_ADJUST is -8589949798 (-2 * TSC_ADJUST_VALUE + -15206).
ok 13 selftests: kvm: vmx_tsc_adjust_test
# selftests: kvm: xss_msr_test
# Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
# Guest physical address width detected: 39
ok 14 selftests: kvm: xss_msr_test
# selftests: kvm: clear_dirty_log_test
# Test iterations: 32, interval: 10 (ms)
# Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
# Guest physical address width detected: 39
# guest physical test memory offset: 0x7fbffef000
# Dirtied 1024 pages
# Total bits checked: dirty (161093), clear (7965867), track_next (24701)
ok 15 selftests: kvm: clear_dirty_log_test
# selftests: kvm: dirty_log_test
# Test iterations: 32, interval: 10 (ms)
# Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
# Guest physical address width detected: 39
# guest physical test memory offset: 0x7fbffef000
# Dirtied 1024 pages
# Total bits checked: dirty (160651), clear (7966309), track_next (24491)
ok 16 selftests: kvm: dirty_log_test
# selftests: kvm: kvm_create_max_vcpus
# KVM_CAP_MAX_VCPU_ID: 1023
# KVM_CAP_MAX_VCPUS: 288
# Testing creating 288 vCPUs, with IDs 0...287.
# Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
# Guest physical address width detected: 39
# Testing creating 288 vCPUs, with IDs 735...1022.
# Testing guest mode: PA-bits:ANY, VA-bits:48,  4K pages
# Guest physical address width detected: 39
ok 17 selftests: kvm: kvm_create_max_vcpus
make: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf6=
8e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kvm'
2020-04-09 08:20:02 make run_tests -C landlock
make: Entering directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf=
68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/landlock'
make --no-builtin-rules ARCH=3Dx86 -C ../../../.. headers_install
make[1]: Entering directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464=
ccf68e19bf7d303022d873141b5e1f7219'
  INSTALL ./usr/include
make[1]: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464c=
cf68e19bf7d303022d873141b5e1f7219'
gcc -Wall -O2 -I../../../../usr/include    test_base.c /usr/src/perf_selfte=
sts-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/=
selftests/kselftest_harness.h /usr/src/perf_selftests-x86_64-rhel-7.6-d9d46=
4ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kselftest.h ../=
=2E./../../usr/include/linux/landlock.h ../kselftest_harness.h common.h  -o=
 /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e=
1f7219/tools/testing/selftests/landlock/test_base
gcc -Wall -O2 -I../../../../usr/include    test_ptrace.c /usr/src/perf_self=
tests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testin=
g/selftests/kselftest_harness.h /usr/src/perf_selftests-x86_64-rhel-7.6-d9d=
464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kselftest.h .=
=2E/../../../usr/include/linux/landlock.h ../kselftest_harness.h common.h  =
-o /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b=
5e1f7219/tools/testing/selftests/landlock/test_ptrace
gcc -Wall -O2 -I../../../../usr/include    test_fs.c /usr/src/perf_selftest=
s-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f7219/tools/testing/se=
lftests/kselftest_harness.h /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464c=
cf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/kselftest.h ../..=
/../../usr/include/linux/landlock.h ../kselftest_harness.h common.h  -o /us=
r/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf7d303022d873141b5e1f72=
19/tools/testing/selftests/landlock/test_fs
gcc -Os -static -o /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e19bf=
7d303022d873141b5e1f7219/tools/testing/selftests/landlock/true true.c
TAP version 13
1..3
# selftests: landlock: test_base
# common.h:37:ruleset_rw.fdinfo:Expected 0 (0) <=3D self->ruleset_fd (18446=
744073709551615)
# ruleset_rw.fdinfo: Test terminated by assertion
# test_base.c:64:global.features:Expected 0 (0) =3D=3D landlock(LANDLOCK_CM=
D_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_features), &attr_fea=
tures) (18446744073709551615)
# global.features: Test terminated by assertion
# test_base.c:89:global.empty_attr_ruleset:Expected errno (38) =3D=3D EINVA=
L (22)
# global.empty_attr_ruleset: Test terminated by assertion
# test_base.c:99:global.empty_attr_path_beneath:Expected errno (38) =3D=3D =
EINVAL (22)
# global.empty_attr_path_beneath: Test terminated by assertion
# test_base.c:109:global.empty_attr_enforce:Expected errno (38) =3D=3D EINV=
AL (22)
# global.empty_attr_enforce: Test terminated by assertion
# [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D] Running 5 tests from 2 test cases.
# [ RUN      ] ruleset_rw.fdinfo
# [     FAIL ] ruleset_rw.fdinfo
# [ RUN      ] global.features
# [     FAIL ] global.features
# [ RUN      ] global.empty_attr_ruleset
# [     FAIL ] global.empty_attr_ruleset
# [ RUN      ] global.empty_attr_path_beneath
# [     FAIL ] global.empty_attr_path_beneath
# [ RUN      ] global.empty_attr_enforce
# [     FAIL ] global.empty_attr_enforce
# [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D] 0 / 5 tests passed.
# [  FAILED  ]
not ok 1 selftests: landlock: test_base # exit=3D1
# selftests: landlock: test_ptrace
# test_ptrace.c:36:global.allow_with_one_domain:Expected 0 (0) =3D=3D landl=
ock(LANDLOCK_CMD_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_featu=
res), &attr_features) (18446744073709551615)
# test_ptrace.c:148:global.allow_with_one_domain:Expected 1 (1) =3D=3D read=
(pipe_child[0], &buf_parent, 1) (0)
# test_ptrace.c:149:global.allow_with_one_domain:Failed to read() sync #2 f=
rom child
# global.allow_with_one_domain: Test terminated by assertion
# test_ptrace.c:36:global.deny_with_parent_domain:Expected 0 (0) =3D=3D lan=
dlock(LANDLOCK_CMD_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_fea=
tures), &attr_features) (18446744073709551615)
# test_ptrace.c:99:global.deny_with_parent_domain:Expected 1 (1) =3D=3D rea=
d(pipe_parent[0], &buf_child, 1) (0)
# test_ptrace.c:100:global.deny_with_parent_domain:Failed to read() sync #1=
 from parent
# global.deny_with_parent_domain: Test terminated by assertion
# test_ptrace.c:36:global.deny_with_sibling_domain:Expected 0 (0) =3D=3D la=
ndlock(LANDLOCK_CMD_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_fe=
atures), &attr_features) (18446744073709551615)
# test_ptrace.c:36:global.deny_with_sibling_domain:Expected 0 (0) =3D=3D la=
ndlock(LANDLOCK_CMD_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_fe=
atures), &attr_features) (18446744073709551615)
# global.deny_with_sibling_domain: Test terminated by assertion
# test_ptrace.c:36:global.allow_sibling_domain:Expected 0 (0) =3D=3D landlo=
ck(LANDLOCK_CMD_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_featur=
es), &attr_features) (18446744073709551615)
# global.allow_sibling_domain: Test terminated by assertion
# test_ptrace.c:36:global.allow_with_nested_domain:Expected 0 (0) =3D=3D la=
ndlock(LANDLOCK_CMD_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_fe=
atures), &attr_features) (18446744073709551615)
# global.allow_with_nested_domain: Test terminated by assertion
# test_ptrace.c:36:global.deny_with_nested_and_parent_domain:Expected 0 (0)=
 =3D=3D landlock(LANDLOCK_CMD_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, size=
of(attr_features), &attr_features) (18446744073709551615)
# global.deny_with_nested_and_parent_domain: Test terminated by assertion
# test_ptrace.c:36:global.deny_with_forked_domain:Expected 0 (0) =3D=3D lan=
dlock(LANDLOCK_CMD_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_fea=
tures), &attr_features) (18446744073709551615)
# global.deny_with_forked_domain: Test terminated by assertion
# [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D] Running 8 tests from 2 test cases.
# [ RUN      ] global.allow_without_domain
# [       OK ] global.allow_without_domain
# [ RUN      ] global.allow_with_one_domain
# [     FAIL ] global.allow_with_one_domain
# [ RUN      ] global.deny_with_parent_domain
# [     FAIL ] global.deny_with_parent_domain
# [ RUN      ] global.deny_with_sibling_domain
# [     FAIL ] global.deny_with_sibling_domain
# [ RUN      ] global.allow_sibling_domain
# [     FAIL ] global.allow_sibling_domain
# [ RUN      ] global.allow_with_nested_domain
# [     FAIL ] global.allow_with_nested_domain
# [ RUN      ] global.deny_with_nested_and_parent_domain
# [     FAIL ] global.deny_with_nested_and_parent_domain
# [ RUN      ] global.deny_with_forked_domain
# [     FAIL ] global.deny_with_forked_domain
# [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D] 1 / 8 tests passed.
# [  FAILED  ]
not ok 2 selftests: landlock: test_ptrace # exit=3D1
# selftests: landlock: test_fs
# common.h:37:ruleset_rw.inval:Expected 0 (0) <=3D self->ruleset_fd (184467=
44073709551615)
# ruleset_rw.inval: Test terminated by assertion
# common.h:37:ruleset_rw.nsfs:Expected 0 (0) <=3D self->ruleset_fd (1844674=
4073709551615)
# ruleset_rw.nsfs: Test terminated by assertion
# test_fs.c:342:layout1.whitelist:Expected 0 (0) =3D=3D landlock(LANDLOCK_C=
MD_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_features), &attr_fe=
atures) (18446744073709551615)
# layout1.whitelist: Test terminated by assertion
# test_fs.c:342:layout1.unhandled_access:Expected 0 (0) =3D=3D landlock(LAN=
DLOCK_CMD_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_features), &=
attr_features) (18446744073709551615)
# layout1.unhandled_access: Test terminated by assertion
# test_fs.c:342:layout1.ruleset_overlap:Expected 0 (0) =3D=3D landlock(LAND=
LOCK_CMD_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_features), &a=
ttr_features) (18446744073709551615)
# layout1.ruleset_overlap: Test terminated by assertion
# test_fs.c:342:layout1.inherit_superset:Expected 0 (0) =3D=3D landlock(LAN=
DLOCK_CMD_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_features), &=
attr_features) (18446744073709551615)
# layout1.inherit_superset: Test terminated by assertion
# test_fs.c:342:layout1.rule_on_mountpoint:Expected 0 (0) =3D=3D landlock(L=
ANDLOCK_CMD_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_features),=
 &attr_features) (18446744073709551615)
# layout1.rule_on_mountpoint: Test terminated by assertion
# test_fs.c:342:layout1.rule_over_mountpoint:Expected 0 (0) =3D=3D landlock=
(LANDLOCK_CMD_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_features=
), &attr_features) (18446744073709551615)
# layout1.rule_over_mountpoint: Test terminated by assertion
# test_fs.c:342:layout1.rule_over_root:Expected 0 (0) =3D=3D landlock(LANDL=
OCK_CMD_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_features), &at=
tr_features) (18446744073709551615)
# layout1.rule_over_root: Test terminated by assertion
# test_fs.c:720:layout1.rule_inside_mount_ns:Expected -1 (18446744073709551=
615) !=3D syscall(SYS_pivot_root, dir_s3d2, dir_s3d3) (18446744073709551615)
# test_fs.c:722:layout1.rule_inside_mount_ns:Failed to pivot_root into "tmp=
/s3d1/s3d2": Invalid argument
#=20
# layout1.rule_inside_mount_ns: Test terminated by assertion
# test_fs.c:342:layout1.mount_and_pivot:Expected 0 (0) =3D=3D landlock(LAND=
LOCK_CMD_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_features), &a=
ttr_features) (18446744073709551615)
# layout1.mount_and_pivot: Test terminated by assertion
# test_fs.c:342:layout1.relative_open:Expected 0 (0) =3D=3D landlock(LANDLO=
CK_CMD_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_features), &att=
r_features) (18446744073709551615)
# layout1.relative_open: Test terminated by assertion
# test_fs.c:342:layout1.relative_chdir:Expected 0 (0) =3D=3D landlock(LANDL=
OCK_CMD_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_features), &at=
tr_features) (18446744073709551615)
# layout1.relative_chdir: Test terminated by assertion
# test_fs.c:342:layout1.relative_chroot_only:Expected 0 (0) =3D=3D landlock=
(LANDLOCK_CMD_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_features=
), &attr_features) (18446744073709551615)
# layout1.relative_chroot_only: Test terminated by assertion
# test_fs.c:342:layout1.relative_chroot_chdir:Expected 0 (0) =3D=3D landloc=
k(LANDLOCK_CMD_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_feature=
s), &attr_features) (18446744073709551615)
# layout1.relative_chroot_chdir: Test terminated by assertion
# test_fs.c:342:layout1.chroot:Expected 0 (0) =3D=3D landlock(LANDLOCK_CMD_=
GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_features), &attr_featu=
res) (18446744073709551615)
# layout1.chroot: Test terminated by assertion
# test_fs.c:342:layout1.execute:Expected 0 (0) =3D=3D landlock(LANDLOCK_CMD=
_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_features), &attr_feat=
ures) (18446744073709551615)
# layout1.execute: Test terminated by assertion
# test_fs.c:342:layout1.link_to:Expected 0 (0) =3D=3D landlock(LANDLOCK_CMD=
_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_features), &attr_feat=
ures) (18446744073709551615)
# layout1.link_to: Test terminated by assertion
# test_fs.c:342:layout1.rename_from:Expected 0 (0) =3D=3D landlock(LANDLOCK=
_CMD_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_features), &attr_=
features) (18446744073709551615)
# layout1.rename_from: Test terminated by assertion
# test_fs.c:342:layout1.rename_to:Expected 0 (0) =3D=3D landlock(LANDLOCK_C=
MD_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_features), &attr_fe=
atures) (18446744073709551615)
# layout1.rename_to: Test terminated by assertion
# test_fs.c:342:layout1.rmdir:Expected 0 (0) =3D=3D landlock(LANDLOCK_CMD_G=
ET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_features), &attr_featur=
es) (18446744073709551615)
# layout1.rmdir: Test terminated by assertion
# test_fs.c:342:layout1.unlink:Expected 0 (0) =3D=3D landlock(LANDLOCK_CMD_=
GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_features), &attr_featu=
res) (18446744073709551615)
# layout1.unlink: Test terminated by assertion
# test_fs.c:342:layout1.make_char:Expected 0 (0) =3D=3D landlock(LANDLOCK_C=
MD_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_features), &attr_fe=
atures) (18446744073709551615)
# layout1.make_char: Test terminated by assertion
# test_fs.c:342:layout1.make_block:Expected 0 (0) =3D=3D landlock(LANDLOCK_=
CMD_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_features), &attr_f=
eatures) (18446744073709551615)
# layout1.make_block: Test terminated by assertion
# test_fs.c:342:layout1.make_reg:Expected 0 (0) =3D=3D landlock(LANDLOCK_CM=
D_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_features), &attr_fea=
tures) (18446744073709551615)
# layout1.make_reg: Test terminated by assertion
# test_fs.c:342:layout1.make_sock:Expected 0 (0) =3D=3D landlock(LANDLOCK_C=
MD_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_features), &attr_fe=
atures) (18446744073709551615)
# layout1.make_sock: Test terminated by assertion
# test_fs.c:342:layout1.make_fifo:Expected 0 (0) =3D=3D landlock(LANDLOCK_C=
MD_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_features), &attr_fe=
atures) (18446744073709551615)
# layout1.make_fifo: Test terminated by assertion
# test_fs.c:342:layout1.make_sym:Expected 0 (0) =3D=3D landlock(LANDLOCK_CM=
D_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_features), &attr_fea=
tures) (18446744073709551615)
# layout1.make_sym: Test terminated by assertion
# test_fs.c:342:layout1.make_dir:Expected 0 (0) =3D=3D landlock(LANDLOCK_CM=
D_GET_FEATURES, LANDLOCK_OPT_GET_FEATURES, sizeof(attr_features), &attr_fea=
tures) (18446744073709551615)
# layout1.make_dir: Test terminated by assertion
# [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D] Running 31 tests from 3 test cases.
# [ RUN      ] layout1.no_restriction
# [       OK ] layout1.no_restriction
# [ RUN      ] ruleset_rw.inval
# [     FAIL ] ruleset_rw.inval
# [ RUN      ] ruleset_rw.nsfs
# [     FAIL ] ruleset_rw.nsfs
# [ RUN      ] layout1.whitelist
# [     FAIL ] layout1.whitelist
# [ RUN      ] layout1.unhandled_access
# [     FAIL ] layout1.unhandled_access
# [ RUN      ] layout1.ruleset_overlap
# [     FAIL ] layout1.ruleset_overlap
# [ RUN      ] layout1.inherit_superset
# [     FAIL ] layout1.inherit_superset
# [ RUN      ] layout1.rule_on_mountpoint
# [     FAIL ] layout1.rule_on_mountpoint
# [ RUN      ] layout1.rule_over_mountpoint
# [     FAIL ] layout1.rule_over_mountpoint
# [ RUN      ] layout1.rule_over_root
# [     FAIL ] layout1.rule_over_root
# [ RUN      ] layout1.rule_inside_mount_ns
# [     FAIL ] layout1.rule_inside_mount_ns
# [ RUN      ] layout1.mount_and_pivot
# [     FAIL ] layout1.mount_and_pivot
# [ RUN      ] layout1.relative_open
# [     FAIL ] layout1.relative_open
# [ RUN      ] layout1.relative_chdir
# [     FAIL ] layout1.relative_chdir
# [ RUN      ] layout1.relative_chroot_only
# [     FAIL ] layout1.relative_chroot_only
# [ RUN      ] layout1.relative_chroot_chdir
# [     FAIL ] layout1.relative_chroot_chdir
# [ RUN      ] layout1.chroot
# [     FAIL ] layout1.chroot
# [ RUN      ] layout1.execute
# [     FAIL ] layout1.execute
# [ RUN      ] layout1.link_to
# [     FAIL ] layout1.link_to
# [ RUN      ] layout1.rename_from
# [     FAIL ] layout1.rename_from
# [ RUN      ] layout1.rename_to
# [     FAIL ] layout1.rename_to
# [ RUN      ] layout1.rmdir
# [     FAIL ] layout1.rmdir
# [ RUN      ] layout1.unlink
# [     FAIL ] layout1.unlink
# [ RUN      ] layout1.make_char
# [     FAIL ] layout1.make_char
# [ RUN      ] layout1.make_block
# [     FAIL ] layout1.make_block
# [ RUN      ] layout1.make_reg
# [     FAIL ] layout1.make_reg
# [ RUN      ] layout1.make_sock
# [     FAIL ] layout1.make_sock
# [ RUN      ] layout1.make_fifo
# [     FAIL ] layout1.make_fifo
# [ RUN      ] layout1.make_sym
# [     FAIL ] layout1.make_sym
# [ RUN      ] layout1.make_dir
# [     FAIL ] layout1.make_dir
# [ RUN      ] global.cleanup
# [       OK ] global.cleanup
# [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D] 2 / 31 tests passed.
# [  FAILED  ]
not ok 3 selftests: landlock: test_fs # exit=3D1
make: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf6=
8e19bf7d303022d873141b5e1f7219/tools/testing/selftests/landlock'
2020-04-09 08:20:05 make run_tests -C lkdtm
make: Entering directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf=
68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm'
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/PANIC.sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/BUG.sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/WARNING.sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/WARNING_MESSAGE.=
sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/EXCEPTION.sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/LOOP.sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/EXHAUST_STACK.sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/CORRUPT_STACK.sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/CORRUPT_STACK_ST=
RONG.sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/CORRUPT_LIST_ADD=
=2Esh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/CORRUPT_LIST_DEL=
=2Esh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/CORRUPT_USER_DS.=
sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/STACK_GUARD_PAGE=
_LEADING.sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/STACK_GUARD_PAGE=
_TRAILING.sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/UNSET_SMEP.sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/DOUBLE_FAULT.sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/UNALIGNED_LOAD_S=
TORE_WRITE.sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/OVERWRITE_ALLOCA=
TION.sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/WRITE_AFTER_FREE=
=2Esh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/READ_AFTER_FREE.=
sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/WRITE_BUDDY_AFTE=
R_FREE.sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/READ_BUDDY_AFTER=
_FREE.sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/SLAB_FREE_DOUBLE=
=2Esh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/SLAB_FREE_CROSS.=
sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/SLAB_FREE_PAGE.sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/SOFTLOCKUP.sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/HARDLOCKUP.sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/SPINLOCKUP.sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/HUNG_TASK.sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/EXEC_DATA.sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/EXEC_STACK.sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/EXEC_KMALLOC.sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/EXEC_VMALLOC.sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/EXEC_RODATA.sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/EXEC_USERSPACE.sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/EXEC_NULL.sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/ACCESS_USERSPACE=
=2Esh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/ACCESS_NULL.sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/WRITE_RO.sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/WRITE_RO_AFTER_I=
NIT.sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/WRITE_KERN.sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/REFCOUNT_INC_OVE=
RFLOW.sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/REFCOUNT_ADD_OVE=
RFLOW.sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/REFCOUNT_INC_NOT=
_ZERO_OVERFLOW.sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/REFCOUNT_ADD_NOT=
_ZERO_OVERFLOW.sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/REFCOUNT_DEC_ZER=
O.sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/REFCOUNT_DEC_NEG=
ATIVE.sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/REFCOUNT_DEC_AND=
_TEST_NEGATIVE.sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/REFCOUNT_SUB_AND=
_TEST_NEGATIVE.sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/REFCOUNT_INC_ZER=
O.sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/REFCOUNT_ADD_ZER=
O.sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/REFCOUNT_INC_SAT=
URATED.sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/REFCOUNT_DEC_SAT=
URATED.sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/REFCOUNT_ADD_SAT=
URATED.sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/REFCOUNT_INC_NOT=
_ZERO_SATURATED.sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/REFCOUNT_ADD_NOT=
_ZERO_SATURATED.sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/REFCOUNT_DEC_AND=
_TEST_SATURATED.sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/REFCOUNT_SUB_AND=
_TEST_SATURATED.sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/REFCOUNT_TIMING.=
sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/ATOMIC_TIMING.sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/USERCOPY_HEAP_SI=
ZE_TO.sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/USERCOPY_HEAP_SI=
ZE_FROM.sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/USERCOPY_HEAP_WH=
ITELIST_TO.sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/USERCOPY_HEAP_WH=
ITELIST_FROM.sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/USERCOPY_STACK_F=
RAME_TO.sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/USERCOPY_STACK_F=
RAME_FROM.sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/USERCOPY_STACK_B=
EYOND.sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/USERCOPY_KERNEL.=
sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/USERCOPY_KERNEL_=
DS.sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/STACKLEAK_ERASIN=
G.sh
install -m 0744 run.sh /usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf68e=
19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm/CFI_FORWARD_PROT=
O.sh
TAP version 13
1..71
# selftests: lkdtm: PANIC.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 1 selftests: lkdtm: PANIC.sh # SKIP
# selftests: lkdtm: BUG.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 2 selftests: lkdtm: BUG.sh # SKIP
# selftests: lkdtm: WARNING.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 3 selftests: lkdtm: WARNING.sh # SKIP
# selftests: lkdtm: WARNING_MESSAGE.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 4 selftests: lkdtm: WARNING_MESSAGE.sh # SKIP
# selftests: lkdtm: EXCEPTION.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 5 selftests: lkdtm: EXCEPTION.sh # SKIP
# selftests: lkdtm: LOOP.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 6 selftests: lkdtm: LOOP.sh # SKIP
# selftests: lkdtm: EXHAUST_STACK.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 7 selftests: lkdtm: EXHAUST_STACK.sh # SKIP
# selftests: lkdtm: CORRUPT_STACK.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 8 selftests: lkdtm: CORRUPT_STACK.sh # SKIP
# selftests: lkdtm: CORRUPT_STACK_STRONG.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 9 selftests: lkdtm: CORRUPT_STACK_STRONG.sh # SKIP
# selftests: lkdtm: CORRUPT_LIST_ADD.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 10 selftests: lkdtm: CORRUPT_LIST_ADD.sh # SKIP
# selftests: lkdtm: CORRUPT_LIST_DEL.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 11 selftests: lkdtm: CORRUPT_LIST_DEL.sh # SKIP
# selftests: lkdtm: CORRUPT_USER_DS.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 12 selftests: lkdtm: CORRUPT_USER_DS.sh # SKIP
# selftests: lkdtm: STACK_GUARD_PAGE_LEADING.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 13 selftests: lkdtm: STACK_GUARD_PAGE_LEADING.sh # SKIP
# selftests: lkdtm: STACK_GUARD_PAGE_TRAILING.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 14 selftests: lkdtm: STACK_GUARD_PAGE_TRAILING.sh # SKIP
# selftests: lkdtm: UNSET_SMEP.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 15 selftests: lkdtm: UNSET_SMEP.sh # SKIP
# selftests: lkdtm: DOUBLE_FAULT.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 16 selftests: lkdtm: DOUBLE_FAULT.sh # SKIP
# selftests: lkdtm: UNALIGNED_LOAD_STORE_WRITE.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 17 selftests: lkdtm: UNALIGNED_LOAD_STORE_WRITE.sh # SKIP
# selftests: lkdtm: OVERWRITE_ALLOCATION.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 18 selftests: lkdtm: OVERWRITE_ALLOCATION.sh # SKIP
# selftests: lkdtm: WRITE_AFTER_FREE.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 19 selftests: lkdtm: WRITE_AFTER_FREE.sh # SKIP
# selftests: lkdtm: READ_AFTER_FREE.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 20 selftests: lkdtm: READ_AFTER_FREE.sh # SKIP
# selftests: lkdtm: WRITE_BUDDY_AFTER_FREE.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 21 selftests: lkdtm: WRITE_BUDDY_AFTER_FREE.sh # SKIP
# selftests: lkdtm: READ_BUDDY_AFTER_FREE.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 22 selftests: lkdtm: READ_BUDDY_AFTER_FREE.sh # SKIP
# selftests: lkdtm: SLAB_FREE_DOUBLE.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 23 selftests: lkdtm: SLAB_FREE_DOUBLE.sh # SKIP
# selftests: lkdtm: SLAB_FREE_CROSS.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 24 selftests: lkdtm: SLAB_FREE_CROSS.sh # SKIP
# selftests: lkdtm: SLAB_FREE_PAGE.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 25 selftests: lkdtm: SLAB_FREE_PAGE.sh # SKIP
# selftests: lkdtm: SOFTLOCKUP.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 26 selftests: lkdtm: SOFTLOCKUP.sh # SKIP
# selftests: lkdtm: HARDLOCKUP.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 27 selftests: lkdtm: HARDLOCKUP.sh # SKIP
# selftests: lkdtm: SPINLOCKUP.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 28 selftests: lkdtm: SPINLOCKUP.sh # SKIP
# selftests: lkdtm: HUNG_TASK.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 29 selftests: lkdtm: HUNG_TASK.sh # SKIP
# selftests: lkdtm: EXEC_DATA.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 30 selftests: lkdtm: EXEC_DATA.sh # SKIP
# selftests: lkdtm: EXEC_STACK.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 31 selftests: lkdtm: EXEC_STACK.sh # SKIP
# selftests: lkdtm: EXEC_KMALLOC.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 32 selftests: lkdtm: EXEC_KMALLOC.sh # SKIP
# selftests: lkdtm: EXEC_VMALLOC.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 33 selftests: lkdtm: EXEC_VMALLOC.sh # SKIP
# selftests: lkdtm: EXEC_RODATA.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 34 selftests: lkdtm: EXEC_RODATA.sh # SKIP
# selftests: lkdtm: EXEC_USERSPACE.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 35 selftests: lkdtm: EXEC_USERSPACE.sh # SKIP
# selftests: lkdtm: EXEC_NULL.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 36 selftests: lkdtm: EXEC_NULL.sh # SKIP
# selftests: lkdtm: ACCESS_USERSPACE.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 37 selftests: lkdtm: ACCESS_USERSPACE.sh # SKIP
# selftests: lkdtm: ACCESS_NULL.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 38 selftests: lkdtm: ACCESS_NULL.sh # SKIP
# selftests: lkdtm: WRITE_RO.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 39 selftests: lkdtm: WRITE_RO.sh # SKIP
# selftests: lkdtm: WRITE_RO_AFTER_INIT.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 40 selftests: lkdtm: WRITE_RO_AFTER_INIT.sh # SKIP
# selftests: lkdtm: WRITE_KERN.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 41 selftests: lkdtm: WRITE_KERN.sh # SKIP
# selftests: lkdtm: REFCOUNT_INC_OVERFLOW.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 42 selftests: lkdtm: REFCOUNT_INC_OVERFLOW.sh # SKIP
# selftests: lkdtm: REFCOUNT_ADD_OVERFLOW.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 43 selftests: lkdtm: REFCOUNT_ADD_OVERFLOW.sh # SKIP
# selftests: lkdtm: REFCOUNT_INC_NOT_ZERO_OVERFLOW.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 44 selftests: lkdtm: REFCOUNT_INC_NOT_ZERO_OVERFLOW.sh # SKIP
# selftests: lkdtm: REFCOUNT_ADD_NOT_ZERO_OVERFLOW.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 45 selftests: lkdtm: REFCOUNT_ADD_NOT_ZERO_OVERFLOW.sh # SKIP
# selftests: lkdtm: REFCOUNT_DEC_ZERO.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 46 selftests: lkdtm: REFCOUNT_DEC_ZERO.sh # SKIP
# selftests: lkdtm: REFCOUNT_DEC_NEGATIVE.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 47 selftests: lkdtm: REFCOUNT_DEC_NEGATIVE.sh # SKIP
# selftests: lkdtm: REFCOUNT_DEC_AND_TEST_NEGATIVE.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 48 selftests: lkdtm: REFCOUNT_DEC_AND_TEST_NEGATIVE.sh # SKIP
# selftests: lkdtm: REFCOUNT_SUB_AND_TEST_NEGATIVE.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 49 selftests: lkdtm: REFCOUNT_SUB_AND_TEST_NEGATIVE.sh # SKIP
# selftests: lkdtm: REFCOUNT_INC_ZERO.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 50 selftests: lkdtm: REFCOUNT_INC_ZERO.sh # SKIP
# selftests: lkdtm: REFCOUNT_ADD_ZERO.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 51 selftests: lkdtm: REFCOUNT_ADD_ZERO.sh # SKIP
# selftests: lkdtm: REFCOUNT_INC_SATURATED.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 52 selftests: lkdtm: REFCOUNT_INC_SATURATED.sh # SKIP
# selftests: lkdtm: REFCOUNT_DEC_SATURATED.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 53 selftests: lkdtm: REFCOUNT_DEC_SATURATED.sh # SKIP
# selftests: lkdtm: REFCOUNT_ADD_SATURATED.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 54 selftests: lkdtm: REFCOUNT_ADD_SATURATED.sh # SKIP
# selftests: lkdtm: REFCOUNT_INC_NOT_ZERO_SATURATED.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 55 selftests: lkdtm: REFCOUNT_INC_NOT_ZERO_SATURATED.sh # SKIP
# selftests: lkdtm: REFCOUNT_ADD_NOT_ZERO_SATURATED.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 56 selftests: lkdtm: REFCOUNT_ADD_NOT_ZERO_SATURATED.sh # SKIP
# selftests: lkdtm: REFCOUNT_DEC_AND_TEST_SATURATED.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 57 selftests: lkdtm: REFCOUNT_DEC_AND_TEST_SATURATED.sh # SKIP
# selftests: lkdtm: REFCOUNT_SUB_AND_TEST_SATURATED.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 58 selftests: lkdtm: REFCOUNT_SUB_AND_TEST_SATURATED.sh # SKIP
# selftests: lkdtm: REFCOUNT_TIMING.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 59 selftests: lkdtm: REFCOUNT_TIMING.sh # SKIP
# selftests: lkdtm: ATOMIC_TIMING.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 60 selftests: lkdtm: ATOMIC_TIMING.sh # SKIP
# selftests: lkdtm: USERCOPY_HEAP_SIZE_TO.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 61 selftests: lkdtm: USERCOPY_HEAP_SIZE_TO.sh # SKIP
# selftests: lkdtm: USERCOPY_HEAP_SIZE_FROM.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 62 selftests: lkdtm: USERCOPY_HEAP_SIZE_FROM.sh # SKIP
# selftests: lkdtm: USERCOPY_HEAP_WHITELIST_TO.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 63 selftests: lkdtm: USERCOPY_HEAP_WHITELIST_TO.sh # SKIP
# selftests: lkdtm: USERCOPY_HEAP_WHITELIST_FROM.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 64 selftests: lkdtm: USERCOPY_HEAP_WHITELIST_FROM.sh # SKIP
# selftests: lkdtm: USERCOPY_STACK_FRAME_TO.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 65 selftests: lkdtm: USERCOPY_STACK_FRAME_TO.sh # SKIP
# selftests: lkdtm: USERCOPY_STACK_FRAME_FROM.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 66 selftests: lkdtm: USERCOPY_STACK_FRAME_FROM.sh # SKIP
# selftests: lkdtm: USERCOPY_STACK_BEYOND.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 67 selftests: lkdtm: USERCOPY_STACK_BEYOND.sh # SKIP
# selftests: lkdtm: USERCOPY_KERNEL.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 68 selftests: lkdtm: USERCOPY_KERNEL.sh # SKIP
# selftests: lkdtm: USERCOPY_KERNEL_DS.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 69 selftests: lkdtm: USERCOPY_KERNEL_DS.sh # SKIP
# selftests: lkdtm: STACKLEAK_ERASING.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 70 selftests: lkdtm: STACKLEAK_ERASING.sh # SKIP
# selftests: lkdtm: CFI_FORWARD_PROTO.sh
# Cannot find /sys/kernel/debug/provoke-crash/DIRECT (missing CONFIG_LKDTM?)
not ok 71 selftests: lkdtm: CFI_FORWARD_PROTO.sh # SKIP
make: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf6=
8e19bf7d303022d873141b5e1f7219/tools/testing/selftests/lkdtm'
locking test: not in Makefile
2020-04-09 08:20:06 make TARGETS=3Dlocking
make --no-builtin-rules ARCH=3Dx86 -C ../../.. headers_install
make[1]: Entering directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464=
ccf68e19bf7d303022d873141b5e1f7219'
  INSTALL ./usr/include
make[1]: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464c=
cf68e19bf7d303022d873141b5e1f7219'
make[1]: Entering directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464=
ccf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/locking'
make[1]: Nothing to be done for 'all'.
make[1]: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464c=
cf68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/locking'
2020-04-09 08:20:06 make run_tests -C locking
make: Entering directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf=
68e19bf7d303022d873141b5e1f7219/tools/testing/selftests/locking'
TAP version 13
1..1
# selftests: locking: ww_mutex.sh
# locking/ww_mutex: ok
ok 1 selftests: locking: ww_mutex.sh
make: Leaving directory '/usr/src/perf_selftests-x86_64-rhel-7.6-d9d464ccf6=
8e19bf7d303022d873141b5e1f7219/tools/testing/selftests/locking'

--lKbk9CFItQTD29wm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="job.yaml"

---

#! jobs/kernel-selftests.yaml
suite: kernel-selftests
testcase: kernel-selftests
category: functional
need_memory: 2G
need_cpu: 2
kernel-selftests:
  group: kselftests-01
kernel_cmdline: kvm-intel.unrestricted_guest=0
job_origin: "/lkp/lkp/.src-20200407-224849/allot/cyclic:p1:linux-devel:devel-hourly/lkp-skl-d01/kernel-selftests.yaml"

#! queue options
queue_cmdline_keys:
- branch
- commit
queue: bisect
testbox: lkp-skl-d01
tbox_group: lkp-skl-d01
submit_id: 5e8e54f5ee27f7112cbeec24
job_file: "/lkp/jobs/scheduled/lkp-skl-d01/kernel-selftests-kselftests-01-ucode=0xd6-debian-x86_64-20191114.cgz-d9d464ccf68e19bf7d303022d873141b5e1f7219-20200409-4396-1iak0y3-0.yaml"
id: 30ed39a4392deac3aaa7c026c046ece9929f0568
queuer_version: "/lkp-src"

#! hosts/lkp-skl-d01
model: Skylake
nr_cpu: 8
memory: 16G
nr_hdd_partitions: 1
hdd_partitions: "/dev/disk/by-id/ata-WDC_WD10EZEX-75WN4A0_WD-WCC6Y2JD9SLU-part1"
swap_partitions: "/dev/disk/by-id/ata-WDC_WD10EZEX-75WN4A0_WD-WCC6Y2JD9SLU-part3"
rootfs_partition: "/dev/disk/by-id/ata-WDC_WD10EZEX-75WN4A0_WD-WCC6Y2JD9SLU-part2"
brand: Intel(R) Core(TM) i7-6700 CPU @ 3.40GHz
cpu_info: skylake i7-6700
bios_version: 1.2.8

#! include/category/functional
kmsg: 
heartbeat: 
meminfo: 

#! include/queue/cyclic
commit: d9d464ccf68e19bf7d303022d873141b5e1f7219

#! include/testbox/lkp-skl-d01
need_kconfig_hw:
- CONFIG_E1000E=y
- CONFIG_SATA_AHCI
ucode: '0xd6'

#! include/kernel-selftests
need_kernel_headers: true
need_kernel_selftests: true
need_kconfig:
- CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
- CONFIG_CHECKPOINT_RESTORE=y
- CONFIG_DRM_DEBUG_SELFTEST=m ~ v(4\.1[8-9]|4\.20|5\.)
- CONFIG_EMBEDDED=y
- CONFIG_EXPERT=y
- CONFIG_GPIOLIB=y
- CONFIG_GPIO_MOCKUP=y
- CONFIG_HIST_TRIGGERS=y
- CONFIG_IR_IMON_DECODER=m ~ v(4\.1[7-9]|4\.20|5\.)
- CONFIG_IR_SHARP_DECODER=m
- CONFIG_LIRC=y
- CONFIG_TEST_BITMAP
- CONFIG_TEST_PRINTF
- CONFIG_TEST_STRSCPY=m ~ v(5\.2$|5\.[3-9])
- CONFIG_WW_MUTEX_SELFTEST=m ~ v(4\.1[1-9]|4\.20|5\.)

#! default params
kconfig: x86_64-rhel-7.6
compiler: gcc-7
enqueue_time: 2020-04-09 06:49:29.511212497 +08:00
_id: 5e8e54f5ee27f7112cbeec24
_rt: "/result/kernel-selftests/kselftests-01-ucode=0xd6/lkp-skl-d01/debian-x86_64-20191114.cgz/x86_64-rhel-7.6/gcc-7/d9d464ccf68e19bf7d303022d873141b5e1f7219"

#! schedule options
user: lkp
head_commit: dc72e287c044cd82644b009e72545e3f5e8d7699
base_commit: 7111951b8d4973bda27ff663f2cf18b663d15b48
branch: linux-devel/devel-hourly-2020040801
rootfs: debian-x86_64-20191114.cgz
result_root: "/result/kernel-selftests/kselftests-01-ucode=0xd6/lkp-skl-d01/debian-x86_64-20191114.cgz/x86_64-rhel-7.6/gcc-7/d9d464ccf68e19bf7d303022d873141b5e1f7219/0"
scheduler_version: "/lkp/lkp/.src-20200408-145327"
LKP_SERVER: inn
arch: x86_64
max_uptime: 3600
initrd: "/osimage/debian/debian-x86_64-20191114.cgz"
bootloader_append:
- root=/dev/ram0
- user=lkp
- job=/lkp/jobs/scheduled/lkp-skl-d01/kernel-selftests-kselftests-01-ucode=0xd6-debian-x86_64-20191114.cgz-d9d464ccf68e19bf7d303022d873141b5e1f7219-20200409-4396-1iak0y3-0.yaml
- ARCH=x86_64
- kconfig=x86_64-rhel-7.6
- branch=linux-devel/devel-hourly-2020040801
- commit=d9d464ccf68e19bf7d303022d873141b5e1f7219
- BOOT_IMAGE=/pkg/linux/x86_64-rhel-7.6/gcc-7/d9d464ccf68e19bf7d303022d873141b5e1f7219/vmlinuz-5.6.0-rc1-00033-gd9d464ccf68e1
- kvm-intel.unrestricted_guest=0
- max_uptime=3600
- RESULT_ROOT=/result/kernel-selftests/kselftests-01-ucode=0xd6/lkp-skl-d01/debian-x86_64-20191114.cgz/x86_64-rhel-7.6/gcc-7/d9d464ccf68e19bf7d303022d873141b5e1f7219/0
- LKP_SERVER=inn
- nokaslr
- selinux=0
- debug
- apic=debug
- sysrq_always_enabled
- rcupdate.rcu_cpu_stall_timeout=100
- net.ifnames=0
- printk.devkmsg=on
- panic=-1
- softlockup_panic=1
- nmi_watchdog=panic
- oops=panic
- load_ramdisk=2
- prompt_ramdisk=0
- drbd.minor_count=8
- systemd.log_level=err
- ignore_loglevel
- console=tty0
- earlyprintk=ttyS0,115200
- console=ttyS0,115200
- vga=normal
- rw
modules_initrd: "/pkg/linux/x86_64-rhel-7.6/gcc-7/d9d464ccf68e19bf7d303022d873141b5e1f7219/modules.cgz"
bm_initrd: "/osimage/deps/debian-x86_64-20180403.cgz/run-ipconfig_2018-04-03.cgz,/osimage/deps/debian-x86_64-20180403.cgz/lkp_2019-08-05.cgz,/osimage/deps/debian-x86_64-20180403.cgz/rsync-rootfs_2018-04-03.cgz,/osimage/deps/debian-x86_64-20180403.cgz/kernel-selftests_20200402.cgz,/osimage/pkg/debian-x86_64-20180403.cgz/kernel-selftests-x86_64-5a3faf29-1_20200331.cgz,/osimage/deps/debian-x86_64-20180403.cgz/hw_2020-01-02.cgz"
linux_headers_initrd: "/pkg/linux/x86_64-rhel-7.6/gcc-7/d9d464ccf68e19bf7d303022d873141b5e1f7219/linux-headers.cgz"
linux_selftests_initrd: "/pkg/linux/x86_64-rhel-7.6/gcc-7/d9d464ccf68e19bf7d303022d873141b5e1f7219/linux-selftests.cgz"
lkp_initrd: "/osimage/user/lkp/lkp-x86_64.cgz"
site: inn

#! /lkp/lkp/.src-20200407-224849/include/site/inn
LKP_CGI_PORT: 80
LKP_CIFS_PORT: 139
oom-killer: 
watchdog: 

#! runtime status
last_kernel: 4.20.0
schedule_notify_address: 

#! user overrides
kernel: "/pkg/linux/x86_64-rhel-7.6/gcc-7/d9d464ccf68e19bf7d303022d873141b5e1f7219/vmlinuz-5.6.0-rc1-00033-gd9d464ccf68e1"
dequeue_time: 2020-04-09 07:31:09.234626615 +08:00

#! /lkp/lkp/.src-20200408-145327/include/site/inn
job_state: finished
loadavg: 5.88 2.72 1.20 2/218 30434
start_time: '1586388724'
end_time: '1586389148'
version: "/lkp/lkp/.src-20200408-145411:33609914:16e4d5e6f"

--lKbk9CFItQTD29wm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=reproduce

 "ln" "-sf" "/usr/bin/clang"
 "ln" "-sf" "/usr/bin/llc"
 "sed" "-i" "s/default_timeout=45/default_timeout=300/" "kselftest/runner.sh"
 "make" "run_tests" "-C" "capabilities"
 "make" "run_tests" "-C" "clone3"
 "make" "run_tests" "-C" "cpu-hotplug"
 "make" "run_tests" "-C" "cpufreq"
 "make" "TARGETS=dmabuf-heaps"
 "make" "run_tests" "-C" "dmabuf-heaps"
 "make" "run_tests" "-C" "exec"
 "mv" "/lib/udev/rules.d/50-firmware.rules" "."
 "/etc/init.d/udev" "restart"
 "make" "run_tests" "-C" "firmware"
 "mv" "50-firmware.rules" "/lib/udev/rules.d/50-firmware.rules"
 "make" "run_tests" "-C" "ftrace"
 "make" "run_tests" "-C" "futex"
 "make" "-C" "../../../tools/gpio"
 "make" "run_tests" "-C" "gpio"
 "make" "TARGETS=ia64"
 "make" "run_tests" "-C" "ia64"
 "make" "run_tests" "-C" "intel_pstate"
 "make" "run_tests" "-C" "ipc"
 "make" "run_tests" "-C" "ir"
 "make" "run_tests" "-C" "kcmp"
 "make" "run_tests" "-C" "kexec"
 "make" "TARGETS=kmod"
 "make" "run_tests" "-C" "kmod"
 "make" "run_tests" "-C" "kvm"
 "make" "run_tests" "-C" "landlock"
 "make" "run_tests" "-C" "lkdtm"
 "make" "TARGETS=locking"
 "make" "run_tests" "-C" "locking"

--lKbk9CFItQTD29wm--
