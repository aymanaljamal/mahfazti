package com.ayman.mahfazti.report;

import java.time.LocalDate;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.ayman.mahfazti.common.exception.ResourceNotFoundException;
import com.ayman.mahfazti.report.dto.DailyReportResponse;
import com.ayman.mahfazti.report.dto.MonthlyReportResponse;
import com.ayman.mahfazti.report.dto.WeeklyReportResponse;
import com.ayman.mahfazti.report.dto.YearlyReportResponse;
import com.ayman.mahfazti.user.User;
import com.ayman.mahfazti.user.UserRepository;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/reports")
@RequiredArgsConstructor
public class ReportController {

    private final ReportService reportService;
    private final UserRepository userRepository;

    private Long currentUserId(Authentication authentication) {
        String email = authentication.getName();
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new ResourceNotFoundException("User not found: " + email));
        return user.getId();
    }

    // GET /api/reports/daily?date=2026-09-02
    @GetMapping("/daily")
    public ResponseEntity<DailyReportResponse> getDailyReport(
            Authentication authentication,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date) {

        LocalDate targetDate = (date != null) ? date : LocalDate.now();
        return ResponseEntity.ok(
                reportService.getDailyReport(currentUserId(authentication), targetDate));
    }

    // GET /api/reports/weekly?date=2026-09-02   (any date that falls inside the target week)
    @GetMapping("/weekly")
    public ResponseEntity<WeeklyReportResponse> getWeeklyReport(
            Authentication authentication,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date) {

        LocalDate targetDate = (date != null) ? date : LocalDate.now();
        return ResponseEntity.ok(
                reportService.getWeeklyReport(currentUserId(authentication), targetDate));
    }

    // GET /api/reports/monthly?year=2026&month=9
    @GetMapping("/monthly")
    public ResponseEntity<MonthlyReportResponse> getMonthlyReport(
            Authentication authentication,
            @RequestParam(required = false) Integer year,
            @RequestParam(required = false) Integer month) {

        LocalDate now = LocalDate.now();
        int targetYear = (year != null) ? year : now.getYear();
        int targetMonth = (month != null) ? month : now.getMonthValue();

        return ResponseEntity.ok(
                reportService.getMonthlyReport(currentUserId(authentication), targetYear, targetMonth));
    }

    // GET /api/reports/yearly?year=2026
    @GetMapping("/yearly")
    public ResponseEntity<YearlyReportResponse> getYearlyReport(
            Authentication authentication,
            @RequestParam(required = false) Integer year) {

        int targetYear = (year != null) ? year : LocalDate.now().getYear();
        return ResponseEntity.ok(
                reportService.getYearlyReport(currentUserId(authentication), targetYear));
    }
}
